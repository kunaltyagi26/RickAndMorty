//
//  SettingsViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import SafariServices
import StoreKit
import SwiftUI
import UIKit

/// Controller to show various app options and settings
final class SettingsViewController: UIViewController {
    private lazy var settingsVC = UIHostingController(
        rootView: SettingsView(
            viewModel: SettingsViewModel(
                cellViewModels: SettingsOption.allCases.compactMap {
                    SettingsCellViewModel(type: $0, onTapHandler: handleTap)
                }
            )
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        addView()
    }
    
    private func addView() {
        addChild(settingsVC)
        settingsVC.didMove(toParent: self)
        
        view.addSubview(settingsVC.view)
        settingsVC.view.constraint(to: view)
    }
    
    private func handleTap(for option: SettingsOption) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            if let url = option.targetUrl {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true)
            } else if option == .rateApp, let windowScene = self.view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
