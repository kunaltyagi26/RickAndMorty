//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 18/10/23.
//

import UIKit

class CharacterPhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    var viewModel: CharacterPhotoCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Private Methods
    private func setupView() {
        imageView.constraint(to: contentView)
        
        contentView.layer.cornerRadius = 8
        imageView.layer.cornerRadius = 8
    }
    
    private func configure() {
        imageView.image = viewModel?.image
    }
}
