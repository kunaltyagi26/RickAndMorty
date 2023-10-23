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
    private let dispatchGroup = DispatchGroup()
    
    private var completion: () -> Void
    
    init(episodeURL: URL?, completion: @escaping () -> Void) {
        self.episodeURL = episodeURL
        self.completion = completion
        
        Task {
            await getEpisode()
            if let episode {
                fetchRelatedCharacters(episode: episode)
            }
        }
    }
    
    var characters: [Character] {
        return dataTuple?.1 ?? []
    }
    
    private func getEpisode() async {
        guard let episodeURL = episodeURL,
              let request = Request(url: episodeURL) else {
            return
        }
    
        let episodeResult = await Service.shared.execute(request, expecting: Episode.self)
        
        switch episodeResult {
        case .success(let episode):
            self.episode = episode
            
        case .failure(let error):
            print(error)
        }
    }
    
    private func fetchRelatedCharacters(episode: Episode) {
        let requests = episode.characters.compactMap {
            URL(string: $0)
        }.compactMap {
            Request(url: $0)
        }
        
        var characters = [Character]()
        
        requests.forEach { request in
            dispatchGroup.enter()
            
            Service.shared.executeThroughCompletion(
                request,
                expecting: Character.self
            ) { characterResult in
                defer {
                    self.dispatchGroup.leave()
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
        case .information:
            return createInformationSection()
            
        case .characters:
            return createCharactersSection()
        }
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
                heightDimension: .absolute(80)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0
        )
        
        return section
    }
    
    private func createCharactersSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 10,
            bottom: 5,
            trailing: 10
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(260)
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
        snapshot.appendSections([.information, .characters])
        
        if let episode = episode {
            let info: [EpisodeDetailViewController.Row] = [
                .info(.init(type: .name, value: episode.name)),
                .info(.init(type: .airDate, value: episode.airDate)),
                .info(.init(type: .episode, value: episode.episode)),
                .info(.init(type: .created, value: episode.created))
            ]
            snapshot.appendItems(info, toSection: .information)
        }
        
        
        if let dataTuple = dataTuple {
            let characters: [EpisodeDetailViewController.Row] = dataTuple.1.compactMap {
                .character(CharacterCollectionViewCellViewModel(character: $0))
            }
            snapshot.appendItems(characters, toSection: .characters)
        }
        
        datasource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    func character(at index: Int) -> Character? {
        return dataTuple?.1[index]
    }
}
