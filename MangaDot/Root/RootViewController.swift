//
//  RootViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 16/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

final class RootViewController: UITabBarController {
    // MARK: - Types

    // MARK: - Properties

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        setupChildViewControllers()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper Methods

    private func setupChildViewControllers() {
        // User Default Theme
        // TODO: Please Change

        let feedViewController = FeedViewController()
        let libraryViewController = LibraryViewController()
        let searchViewController = SearchViewController()
        let settingsViewController = SettingsViewController()

        feedViewController.title = "FeedViewController.title".localized()
        libraryViewController.title = "LibraryViewController.title".localized()
        searchViewController.title = "SearchViewController.title".localized()
        settingsViewController.title = "SettingsViewController.title".localized()

        let readnowNavigationController = UINavigationController(rootViewController: feedViewController)
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)

        readnowNavigationController.navigationBar.isHidden = true
        libraryNavigationController.navigationBar.isHidden = true
        searchNavigationController.navigationBar.isHidden = true
        settingsNavigationController.navigationBar.isHidden = true

        // Setup Tab Bars
        readnowNavigationController.tabBarItem = UITabBarItem(
            title: feedViewController.title,
            image: nil,
            selectedImage: nil
        )

        libraryNavigationController.tabBarItem = UITabBarItem(
            title: libraryViewController.title,
            image: nil,
            selectedImage: nil
        )

        searchNavigationController.tabBarItem = UITabBarItem(
            title: searchViewController.title,
            image: nil,
            selectedImage: nil
        )

        settingsNavigationController.tabBarItem = UITabBarItem(
            title: settingsViewController.title,
            image: nil,
            selectedImage: nil
        )

        // Add Child View Controllers
        addChild(readnowNavigationController)
        addChild(libraryNavigationController)
        addChild(searchNavigationController)
        addChild(settingsNavigationController)

        readnowNavigationController.didMove(toParent: self)
        libraryNavigationController.didMove(toParent: self)
        searchNavigationController.didMove(toParent: self)
        settingsNavigationController.didMove(toParent: self)
    }
}
