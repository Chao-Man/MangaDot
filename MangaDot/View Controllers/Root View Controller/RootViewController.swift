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
    
    private let readnowTableViewController: ReadnowTableViewController = {
        guard let readnowViewController = UIStoryboard.main.instantiateViewController(withIdentifier: ReadnowTableViewController.storyboardIdentifier) as? ReadnowTableViewController else {
            fatalError("Unable to Instantiate Day View Controller")
        }
        readnowViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return readnowViewController
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

