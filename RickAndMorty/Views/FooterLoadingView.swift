//
//  FooterLoadingView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 15/10/23.
//

import UIKit

class FooterLoadingView: UICollectionReusableView {
    // MARK: - UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle Elements
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupView() {
        self.backgroundColor = .systemBackground
        activityIndicator.center(to: self)
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}
