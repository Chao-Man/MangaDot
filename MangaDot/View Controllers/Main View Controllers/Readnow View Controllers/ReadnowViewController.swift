//
//  ReadnowTableViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 24/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import SnapKit

class ReadnowViewController: UIViewController, UINavigationBarDelegate, UIScrollViewDelegate {
    
    // MARK: - Types
    private enum AlertType {
        case noFeedDataAvailable
    }
    
    // MARK: - Properties
    var stackView: UIStackView!
    var scrollView: UIScrollView!
    var carouselViewControllers: [CarouselViewController] = []
    
    var viewModel: ReadnowViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            setupChildViewControllers(with: viewModel)
            viewModel.fetchFeedData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - View Life Cycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - Helper Methods
    private func setupChildViewControllers(with viewModel: ReadnowViewModel) {
        let pushTitle: CarouselViewModel.PushTitle = { [weak self] (titleId, title) in
            if let id = titleId {
                let titleViewController = TitleViewController()
                let titleViewModel = TitleViewModel(titleId: id)
                titleViewController.viewModel = titleViewModel
                titleViewController.title = title
                self?.navigationController?.pushViewController(titleViewController, animated: true)
            }
        }
        
        // Create View Controllers for fetched data
        viewModel.didFetchFeedData = { [weak self] (feedData, error) in
            if let _ = error {
                self?.presentAlert(of: .noFeedDataAvailable)
            }
            else if let feedData = feedData {
                // Initalise new Carousel View Controller for each section
                feedData.sections.forEach({ section in
                    // Init new Carousel View Controller
                    let carouselViewController = CarouselViewController()
                    // Init new Carousel View Model, and assign it to Carousel View Controller
                    let carouselViewModel = CarouselViewModel(sectionData: section, pushTitle: pushTitle)
                    carouselViewController.viewModel = carouselViewModel
                    // Add Carousel View Controller as Child
                    self?.addChild(carouselViewController)
                    carouselViewController.didMove(toParent: self)
                    // Add Carouse View to Stack View
                    self?.stackView.addArrangedSubview(carouselViewController.view)
                })
            } else {
                // Notify User
                self?.presentAlert(of: .noFeedDataAvailable)
            }
            
        }
    }
    
    private func setupViews() {
        // Customise view
        self.view.backgroundColor = .white
        
        // Initialise views
        scrollView = UIScrollView()
        stackView = UIStackView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // Set Scroll View Params
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        
        // Set Stack View Params
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // Set ScrollView Layout
        scrollView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view)
        }
        
        // Set StackView Layout
        stackView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(scrollView)
            make.trailing.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    // MARK: -
    
    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String
        
        switch alertType {
        case .noFeedDataAvailable:
            title = "Unable to Fetch Feed Data"
            message = "The application is unable to fetch weather data. Please make sure your device is connected over Wi-Fi or cellular."
        }
        
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        present(alertController, animated: true)
    }
    
    // MARK: - Delegate Methods
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
