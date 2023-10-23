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
        case photo
        case information
    }
    
    enum Row: Hashable {
        case photo(UUID)
        case info(UUID)
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
        self.viewModel = EpisodeDetailViewModel(episodeURL: episodeURL) {
            print("Everything downloaded")
        }
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
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        setupCollectionView()
    }
    
    /// To setup collection view
    private func setupCollectionView() {
        collectionView.constraint(to: view)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        viewModel?.updateSnapshot(datasource: dataSource)
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.viewModel?.createSection(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            CharacterPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: "\(CharacterPhotoCollectionViewCell.self)"
        )
        collectionView.register(
            CharacterInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: "\(CharacterInfoCollectionViewCell.self)"
        )
        collectionView.register(
            CharacterEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: "\(CharacterEpisodeCollectionViewCell.self)"
        )
        return collectionView
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Row> {
        return UICollectionViewDiffableDataSource<Section, Row>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            switch item {
            case .photo(let photoVM):
                return self?.getPhotoCell(indexPath: indexPath)
                
            case .info(let infoVM):
                return self?.getInfoCell(indexPath: indexPath)
            }
        }
    }
    
    private func getPhotoCell(
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CharacterPhotoCollectionViewCell.self)",
            for: indexPath
        ) as? CharacterPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        //cell.viewModel = photoVM
        return cell
    }
    
    private func getInfoCell(
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CharacterInfoCollectionViewCell.self)",
            for: indexPath
        ) as? CharacterInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        //cell.viewModel = infoVM
        return cell
    }
    
    
    @objc
    private func didTapShare() {
        
    }
}

extension EpisodeDetailViewController: UICollectionViewDelegate {
    
}
