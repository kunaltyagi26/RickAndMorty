//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import SwiftUI
import UIKit

/// Controller to show and search for Locations
final class LocationViewController: UIViewController {
    private lazy var locationVC = UIHostingController(
        rootView: LocationView(
            viewModel: LocationViewModel()
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Location"
        
        setupView()
    }
    
    private func setupView() {
        addView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    private func addView() {
        addChild(locationVC)
        locationVC.didMove(toParent: self)
        
        view.addSubview(locationVC.view)
        locationVC.view.constraint(to: view)
    }
    
    @objc
    private func didTapSearch() {
        let searchVC = SearchViewController(config: .init(type: .location))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
