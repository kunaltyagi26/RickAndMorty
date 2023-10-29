//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 18/10/23.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    var viewModel: CharacterEpisodeCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    // MARK: - UI Elements
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
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
        
        seasonLabel.text = ""
        nameLabel.text = ""
        airDateLabel.text = ""
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.backgroundColor = .tertiarySystemBackground
        setupLayer()
        
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
        
        addConstraints()
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            seasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            seasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
        ])
    }
    
    private func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        contentView.layer.borderColor = viewModel.borderColor.cgColor 
        
        viewModel.registerDataBlock {[weak self] in
            guard let self = self else {
                return
            }
            
            self.seasonLabel.text = viewModel.seasonName
            self.nameLabel.text = viewModel.episodeName
            self.airDateLabel.text = viewModel.airDate
        }
        
        viewModel.fetchEpisode()
    }
}
