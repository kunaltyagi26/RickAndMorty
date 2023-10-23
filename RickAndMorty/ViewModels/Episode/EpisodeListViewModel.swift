//
//  EpisodeListViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 20/10/23.
//

import UIKit

final class EpisodeListViewModel {
    /// Describes the event happening
    enum Event {
        case startLoading
        case stopLoading
        case refreshData
        case showError
    }
    
    typealias EventHandler = (Event) -> Void
    
    private var eventHandler: EventHandler
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemMint,
        .systemIndigo
    ]
    
    var episodes = [Episode]() {
        didSet {
            cellViewModels = episodes.compactMap {
                return CharacterEpisodeCollectionViewCellViewModel(
                    episodeURL: $0.url,
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
            }
        }
    }
    
    var cellViewModels = [CharacterEpisodeCollectionViewCellViewModel]()
    
    var apiInfo: EpisodesResponse.Info?
    
    init(eventHandler: @escaping EventHandler) {
        self.eventHandler = eventHandler
        fetchEpisodes()
    }
    
    var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
    /// Fetch initial set of episodes(20)
    private func fetchEpisodes(
        request: Request = Request(endpoint: .episode),
        isInitialFetch: Bool = true
    ) {
        Task {
            if isInitialFetch {
                eventHandler(.startLoading)
            }
            
            let result = await Service.shared.execute(
                request,
                expecting: EpisodesResponse.self
            )
            
            if isInitialFetch {
                eventHandler(.stopLoading)
            }
            
            switch result {
            case .success(let episodesResponse):
                if episodes.isEmpty {
                    episodes = episodesResponse.results
                } else {
                    episodes.append(contentsOf: episodesResponse.results)
                }
                
                apiInfo = episodesResponse.info
                eventHandler(.refreshData)
                
            case .failure(let error):
                print(error)
                eventHandler(.showError)
            }
        }
    }
    
    func fetchAdditionalEpisodes() {
        guard let nextUrlString = apiInfo?.next,
              let nextUrl = URL(string: nextUrlString),
              let request = Request(url: nextUrl) else {
            return
        }
        
        self.fetchEpisodes(request: request)
    }
}
