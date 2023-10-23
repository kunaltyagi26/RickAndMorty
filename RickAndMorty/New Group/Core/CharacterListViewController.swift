//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import UIKit

/// Controller to show and search for Characters
final class CharacterListViewController: UIViewController {
    // MARK: - Enums
    enum Section {
        case all
    }
    
    // MARK: - Variables
    private var characterListViewModel: CharacterListViewModel?
    lazy var dataSource = configureDataSource()
    private var isLoadingMoreCharacters = false
    
    // MARK: - UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        flowLayout.sectionFootersPinToVisibleBounds = false
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        
        collectionView.register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: "\(CharacterCollectionViewCell.self)"
        )
        collectionView.register(
            FooterLoadingView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "\(FooterLoadingView.self)"
        )
        
        collectionView.isHidden = true
        collectionView.alpha = 0
        return collectionView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        characterListViewModel = CharacterListViewModel(eventHandler: handleEvent)
    }
    
    // MARK: - Private Methods
    
    /// To setup view
    private func setupView() {
        setupCollectionView()
        activityIndicator.center(to: view)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    /// To setup collection view
    private func setupCollectionView() {
        collectionView.constraint(to: view)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    /// To handle all the events with respect to this controller
    /// - Parameter event: type of event
    private func handleEvent(event: CharacterListViewModel.Event) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            switch event {
            case .startLoading:
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
            case .stopLoading:
                self.activityIndicator.stopAnimating()
                
            case .refreshData:
                self.collectionView.isHidden = false
                self.updateSnapshot()
                UIView.animate(withDuration: 0.4) {
                    self.collectionView.alpha = 1
                }
                isLoadingMoreCharacters = false
                
            case .showError:
                isLoadingMoreCharacters = false
            }
        }
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Character> {
        let datasource = UICollectionViewDiffableDataSource<Section, Character>(
            collectionView: self.collectionView
        ) { [weak self] collectionView, indexPath, character in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(CharacterCollectionViewCell.self)",
                    for: indexPath
                  ) as? CharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = self.characterListViewModel?.cellViewModels[indexPath.row]
            return cell
        }
        
        datasource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            guard elementKind == UICollectionView.elementKindSectionFooter,
                  let footerLoadingView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: "\(FooterLoadingView.self)",
                    for: indexPath
                  ) as? FooterLoadingView else {
                return nil
            }
            footerLoadingView.startAnimating()
            return footerLoadingView
        }
        
        return datasource
    }
    
    private func updateSnapshot(animatingChange: Bool = false) {
        guard let characters = characterListViewModel?.characters else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.all])
        snapshot.appendItems(characters, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    @objc
    private func didTapSearch() {
        let searchVC = SearchViewController(config: .init(type: .character))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let shouldShow = self.characterListViewModel?.shouldShowLoadMoreIndicator,
              shouldShow else {
            return .zero
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate
extension CharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let character = characterListViewModel?.characters[indexPath.row] else {
            return
        }
        
        let detailVC = CharacterDetailViewController(
            character: character
        )
        detailVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension CharacterListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let shouldShow = self.characterListViewModel?.shouldShowLoadMoreIndicator,
              shouldShow,
              !isLoadingMoreCharacters else {
            return
        }
        
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewFixedHeight = scrollView.frame.size.height
        
        if offset >= contentHeight - scrollViewFixedHeight - 70 {
            isLoadingMoreCharacters = true
            characterListViewModel?.fetchAdditionalCharacters()
        }
    }
}
