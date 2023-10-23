//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import UIKit

/// View model to handle character detail view logic
final class CharacterDetailViewModel {
    private let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    var title: String {
        return character.name.uppercased()
    }
    
    var url: URL? {
        return URL(string: character.url)
    }
    
    // MARK: - Layout
    func createSection(for index: Int) -> NSCollectionLayoutSection? {
        guard let section = CharacterDetailViewController.Section(rawValue: index) else {
            return nil
        }
        
        switch section {
        case .photo:
            return createPhotoSection()
            
        case .information:
            return createInformationSection()
            
        case .episodes:
            return createEpisodesSection()
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
    
    private func createEpisodesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 8
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func updateSnapshot(
        datasource: UICollectionViewDiffableDataSource<CharacterDetailViewController.Section, CharacterDetailViewController.Row>,
        animatingChange: Bool = false
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<CharacterDetailViewController.Section, CharacterDetailViewController.Row>()
        snapshot.appendSections([.photo, .information, .episodes])
        snapshot.appendItems(
            [.photo(
                CharacterPhotoCollectionViewCellViewModel(
                    characterImageUrl: character.image
                ))],
            toSection: .photo
        )
        
        let info: [CharacterDetailViewController.Row] = [
            .info(.init(type: .status, value: character.status.text)),
            .info(.init(type: .gender, value: character.gender.text)),
            .info(.init(type: .type, value: character.type)),
            .info(.init(type: .species, value: character.species)),
            .info(.init(type: .origin, value: character.origin.name)),
            .info(.init(type: .location, value: character.location.name)),
            .info(.init(type: .created, value: character.created)),
            .info(.init(type: .episodeCount, value: "\(character.episode.count)"))
        ]
        snapshot.appendItems(info, toSection: .information)
        
        let episodes: [CharacterDetailViewController.Row] = character.episode.compactMap {
            .episode(.init(episodeURL: $0))
        }
        snapshot.appendItems(episodes, toSection: .episodes)
        datasource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
}

