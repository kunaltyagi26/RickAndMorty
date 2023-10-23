//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 19/10/23.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    // MARK: - Enums
    enum Section: Int {
        case information
        case characters
    }
    
    enum Row: Hashable {
        case info(EpisodeInfoCollectionViewCellViewModel)
        case character(CharacterCollectionViewCellViewModel)
    }
    
    // MARK: - Variables
    var viewModel: EpisodeDetailViewModel?
    lazy var dataSource = configureDataSource()
    
    // MARK: - UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        createCollectionView()
    }()
    
    // MARK: - Lifecycle Methods
    init(episodeURL: URL?) {
        super.init(nibName: nil, bundle: nil)
        activityIndicator.startAnimating()
        viewModel = EpisodeDetailViewModel(episodeURL: episodeURL) { [weak self] in
            guard let self = self,
                  let viewModel = self.viewModel else {
                return
            }
            
            DispatchQueue.main.async {
                viewModel.updateSnapshot(datasource: self.dataSource)
                self.activityIndicator.stopAnimating()
            }
        }
        
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
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        setupCollectionView()
        
        activityIndicator.center(to: view)
    }
    
    /// To setup collection view
    private func setupCollectionView() {
        collectionView.constraint(to: view)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.viewModel?.createSection(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            EpisodeInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: "\(EpisodeInfoCollectionViewCell.self)"
        )
        collectionView.register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: "\(CharacterCollectionViewCell.self)"
        )
        return collectionView
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Row> {
        return UICollectionViewDiffableDataSource<Section, Row>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            switch item {
            case .info(let infoVM):
                return self?.getInfoCell(
                    infoVM: infoVM,
                    indexPath: indexPath
                )
                
            case .character(let characterVM):
                return self?.getCharacterCell(
                    characterVM: characterVM,
                    indexPath: indexPath
                )
            }
        }
    }
    
    private func getInfoCell(
        infoVM: EpisodeInfoCollectionViewCellViewModel,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(EpisodeInfoCollectionViewCell.self)",
            for: indexPath
        ) as? EpisodeInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = infoVM
        return cell
    }
    
    private func getCharacterCell(
        characterVM: CharacterCollectionViewCellViewModel,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CharacterCollectionViewCell.self)",
            for: indexPath
        ) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = characterVM
        return cell
    }
    
    @objc
    private func didTapShare() {
        
    }
}

extension EpisodeDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .info(_):
            break
            
        case .character(_):
            guard let character = viewModel?.character(at: indexPath.row) else {
                return
            }
            
            let characterDetailVC = CharacterDetailViewController(
                character: character
            )
            self.navigationController?.pushViewController(characterDetailVC, animated: true)
        }
    }
}
