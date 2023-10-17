//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    // MARK: - Variables
    let viewModel: CharacterDetailViewModel
    
    // MARK: - Lifecycle Methods
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
}
