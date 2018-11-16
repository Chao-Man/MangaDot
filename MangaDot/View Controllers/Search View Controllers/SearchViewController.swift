//
//  SearchViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 24/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties

    var viewModel: SearchViewModel!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper Methods

    private func setupChildViewControllers() {}

    private func setupViews() {
        // Customise view
        view.backgroundColor = .white
    }
}
