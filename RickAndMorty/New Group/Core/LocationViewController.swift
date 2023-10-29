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
        
        addView()
    }
    
    private func addView() {
        addChild(locationVC)
        locationVC.didMove(toParent: self)
        
        view.addSubview(locationVC.view)
        locationVC.view.constraint(to: view)
    }
}
