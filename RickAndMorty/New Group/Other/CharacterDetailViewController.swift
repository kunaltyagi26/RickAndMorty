//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    // MARK: - Enums
    @frozen
    enum Section: Int {
        case photo
        case information
        case episodes
    }
    
    enum Row: Hashable {
        case photo(CharacterPhotoCollectionViewCellViewModel)
        case info(CharacterInfoCollectionViewCellViewModel)
        case episode(CharacterEpisodeCollectionViewCellViewModel)
    }
    
    // MARK: - Variables
    let viewModel: CharacterDetailViewModel
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
    init(character: Character) {
        self.viewModel = CharacterDetailViewModel(character: character)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        self.collectionView = createCollectionView()
        setupCollectionView()
        
        activityIndicator.center(to: view)
    }
    
    /// To setup collection view
    private func setupCollectionView() {
        collectionView.constraint(to: view)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        viewModel.updateSnapshot(datasource: dataSource)
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.viewModel.createSection(for: sectionIndex)
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
                return self?.getPhotoCell(photoVM: photoVM, indexPath: indexPath)
                
            case .info(let infoVM):
                return self?.getInfoCell(infoVM: infoVM, indexPath: indexPath)
                
            case .episode(let episodeVM):
                return self?.getEpisodeCell(episodeVM: episodeVM, indexPath: indexPath)
            }
        }
    }
    
    private func getPhotoCell(
        photoVM: CharacterPhotoCollectionViewCellViewModel,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CharacterPhotoCollectionViewCell.self)",
            for: indexPath
        ) as? CharacterPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = photoVM
        return cell
    }
    
    private func getInfoCell(
        infoVM: CharacterInfoCollectionViewCellViewModel,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CharacterInfoCollectionViewCell.self)",
            for: indexPath
        ) as? CharacterInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = infoVM
        return cell
    }
    
    private func getEpisodeCell(
        episodeVM: CharacterEpisodeCollectionViewCellViewModel,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(CharacterEpisodeCollectionViewCell.self)",
            for: indexPath
        ) as? CharacterEpisodeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = episodeVM
        return cell
    }
    
    @objc
    private func didTapShare() {
        
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .photo(_), .info(_):
            break
            
        case .episode(let episodeVM):
            let episodeVC = EpisodeDetailViewController(episodeURL: episodeVM.url)
            self.navigationController?.pushViewController(episodeVC, animated: true)
        }
    }
}
