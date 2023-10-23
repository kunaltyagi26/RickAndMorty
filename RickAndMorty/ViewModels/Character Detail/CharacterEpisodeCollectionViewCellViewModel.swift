//
//  CharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 18/10/23.
//

import UIKit

final class CharacterEpisodeCollectionViewCellViewModel {
    private let id = UUID()
    private let episodeURL: String
    let borderColor: UIColor
    private var isFetchingEpisode = false
    
    private var episode: Episode? {
        didSet {
            dataBlock?()
        }
    }
    
    private var dataBlock: (() -> Void)?
    
    var seasonName: String {
        return "Episode \(episode?.episode ?? "Unknown")"
    }
    
    var episodeName: String {
        return episode?.name ?? "Unknown"
    }
    
    var airDate: String {
        return " Aired on \(episode?.airDate ?? "Unknown")"
    }
    
    var url: URL? {
        return URL(string: episodeURL)
    }
    
    init(episodeURL: String, borderColor: UIColor = .systemBlue) {
        self.episodeURL = episodeURL
        self.borderColor = borderColor
    }
    
    func registerDataBlock(_ block: @escaping() -> Void) {
        dataBlock = block
    }
    
    func fetchEpisode() {
        guard !isFetchingEpisode else {
            dataBlock?()
            return
        }
        
        guard let episodeURL = URL(string: episodeURL),
        let request = Request(url: episodeURL) else {
            return
        }
        
        isFetchingEpisode = true
        
        Task {
            let episodeResult = await Service.shared.execute(request, expecting: Episode.self)
            
            switch episodeResult {
            case .success(let episode):
                DispatchQueue.main.async { [weak self] in
                    self?.episode = episode
                }
            
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CharacterEpisodeCollectionViewCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (
        lhs: CharacterEpisodeCollectionViewCellViewModel,
        rhs: CharacterEpisodeCollectionViewCellViewModel)
    -> Bool {
        lhs.id == rhs.id
    }
}
