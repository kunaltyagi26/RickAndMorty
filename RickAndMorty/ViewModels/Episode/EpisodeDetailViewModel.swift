//
//  EpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 20/10/23.
//

import UIKit

final class EpisodeDetailViewModel {
    private var episodeURL: URL?
    private var episode: Episode?
    private var dataTuple: (Episode, [Character])? {
        didSet {
            completion()
        }
    }
    
    private var completion: () -> Void
    
    init(episodeURL: URL?, completion: @escaping () -> Void) {
        self.episodeURL = episodeURL
        self.completion = completion
        getEpisode()
    }
    
    var characters: [Character] {
        return dataTuple?.1 ?? []
    }
    
    private func getEpisode() {
        guard let episodeURL = episodeURL,
              let request = Request(url: episodeURL) else {
            return
        }
        
        Task {
            let episodeResult = await Service.shared.execute(request, expecting: Episode.self)
            
            switch episodeResult {
            case .success(let episode):
                self.episode = episode
                fetchRelatedCharacters(episode: episode)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: Episode) {
        let requests = episode.characters.compactMap {
            URL(string: $0)
        }.compactMap {
            Request(url: $0)
        }
        
        let dispatchGroup = DispatchGroup()
        var characters = [Character]()
        
        requests.forEach { request in
            dispatchGroup.enter()
            
            Service.shared.executeThroughCompletion(
                request,
                expecting: Character.self
            ) { characterResult in
                defer {
                    dispatchGroup.leave()
                }
                
                switch characterResult {
                case .success(let character):
                    characters.append(character)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
    
    // MARK: - Layout
    func createSection(for index: Int) -> NSCollectionLayoutSection? {
        guard let section = EpisodeDetailViewController.Section(rawValue: index) else {
            return nil
        }
        
        switch section {
        case .photo:
            return createPhotoSection()
            
        case .information:
            return createInformationSection()
        }
    }
    
    private func createPhotoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.4)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createInformationSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func updateSnapshot(
        datasource: UICollectionViewDiffableDataSource<EpisodeDetailViewController.Section, EpisodeDetailViewController.Row>,
        animatingChange: Bool = false
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<EpisodeDetailViewController.Section, EpisodeDetailViewController.Row>()
        snapshot.appendSections([.photo, .information])
        datasource.apply(snapshot, animatingDifferences: animatingChange)
    }
}
