//
//  AppDelegate.swift
//  Example-iOS
//
//  Created by Spiros Gerokostas on 01/03/16.
//  Copyright © 2016 SnapKit Team. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let listViewController: ListViewController = ListViewController()
        let navigationController: UINavigationController = UINavigationController(rootViewController: listViewController)

        window!.rootViewController = navigationController

        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()

        return true
    }
}
