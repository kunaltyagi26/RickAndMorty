//
//  EpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 23/10/23.
//

import UIKit

final class EpisodeInfoCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    var viewModel: EpisodeInfoCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
    
        contentView.addSubviews(titleLabel, valueLabel)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.46),
            
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 0),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        titleLabel.text = viewModel.type.displayName
        titleLabel.textColor = viewModel.type.tintColor
        valueLabel.text = viewModel.displayName
    }
}
