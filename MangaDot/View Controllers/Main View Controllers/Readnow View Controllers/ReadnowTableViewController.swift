//
//  ReadnowTableViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 24/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class ReadnowTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let latestCarouselViewController: CarouselViewController = {
        guard let carouselViewController = UIStoryboard.main.instantiateViewController(withIdentifier: CarouselViewController.storyboardIdentifier) as? CarouselViewController else {
            fatalError("Unable to Instantiate Carousel View Controller")
        }
        return carouselViewController
    }()
 
    // MARK: - Helper Methods
    
    private func setupChildViewControllers() {
        
    }
}
