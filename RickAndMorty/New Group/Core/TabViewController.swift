//
//  TabViewController.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class TabViewController: UITabBarController {
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    // MARK: - Private Methods
    private func setupTabs() {
        let charactersVC = CharacterListViewController()
        let locationVC = LocationViewController()
        let episodeVC = EpisodeListViewController()
        let settingsVC = SettingsViewController()
        
        for viewController in [charactersVC, locationVC, episodeVC, settingsVC] {
            viewController.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 0
        )
        nav2.tabBarItem = UITabBarItem(
            title: "Location",
            image: UIImage(systemName: "globe"),
            tag: 1
        )
        nav3.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 2
        )
        nav4.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 3
        )
        
        for navigationController in [nav1, nav2, nav3, nav4] {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true
        )
    }
}

