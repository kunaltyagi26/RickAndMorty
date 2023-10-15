//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import UIKit

/// Controller to show and search for Characters
final class CharacterViewController: UIViewController {
    // MARK: - Enums
    enum Section {
        case all
    }
    
    // MARK: - Variables
    private var characterListViewModel: CharacterListViewModel?
    lazy var dataSource = configureDataSource()
    
    // MARK: - UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "\(CharacterCollectionViewCell.self)")
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
            case .showError:
                break
            }
        }
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Character> {
        UICollectionViewDiffableDataSource<Section, Character>(
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
}

// MARK: - UICollectionViewDelegateFlowLayout Delegate
extension CharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
}
