//
//  RootViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 16/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Hero
import Kingfisher
import SnapKit
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

        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 200

        let readnowViewController = ReadnowViewController()
        let libraryViewController = LibraryViewController()
        let searchViewController = SearchViewController()
        let settingsViewController = SettingsViewController()

        readnowViewController.title = "ReadnowViewController.title".localized()
        libraryViewController.title = "LibraryViewController.title".localized()
        searchViewController.title = "SearchViewController.title".localized()
        settingsViewController.title = "SettingsViewController.title".localized()

        let readnowNavigationController = UINavigationController(rootViewController: readnowViewController)
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)

        // Set Child View Controller Models
        readnowViewController.viewModel = ReadnowViewModel()
        libraryViewController.viewModel = LibraryViewModel()
        searchViewController.viewModel = SearchViewModel()
        settingsViewController.viewModel = SettingsViewModel()

        // Setup Tab Bars
        readnowNavigationController.tabBarItem = UITabBarItem(
            title: readnowViewController.title,
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
