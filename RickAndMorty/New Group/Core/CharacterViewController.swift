//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import UIKit

/// Controller to show and search for Characters
final class CharacterViewController: UIViewController {
    private var characterListViewModel: CharacterListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        characterListViewModel = CharacterListViewModel(eventHandler: handleEvent)
    }
    
    private func handleEvent(event: CharacterListViewModel.Event) {
        switch event {
        case .startLoading:
            break
        case .stopLoading:
            break
        case .refreshData:
            break
        case .showError:
            break
        }
    }
}
