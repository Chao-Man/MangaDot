//
//  ReadnowTableViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 24/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import SnapKit
import UIKit

protocol ReadnowViewControllerView {
    func displayStack(title: String, viewModel: CarouselViewModel)
}

class ReadnowViewController: UIViewController, UINavigationBarDelegate, UIScrollViewDelegate {
    // MARK: - Types

    private enum AlertType {
        case noFeedDataAvailable
    }

    // MARK: - Properties

    let stackView = SeparatedStackView()
    let scrollView = UIScrollView()
    var carouselViewControllers: [CarouselViewController] = []

    var viewModel: ReadnowViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            setupViewModel(with: viewModel)
            viewModel.refresh()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
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

    override func updateViewConstraints() {
        // Set ScrollView Layout
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
        }

        // Set StackView Layout
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
        }
        super.updateViewConstraints()
    }

    // MARK: - Helper Methods

    private func setupViewModel(with viewModel: ReadnowViewModel) {
        // Configure View Model
        viewModel.didFetchFeedData = { [weak self] result in
            switch result {
            case let .success(feedData):
                // Remove prior sections
                self?.removeAllSections()
                // Add sections using Feed Data
                self?.addSections(feedData: feedData)
            case let .failure(error):
                let alertType: AlertType

                switch error {
                case .noFeedDataAvailable:
                    alertType = .noFeedDataAvailable
                }

                // Notify User
                self?.presentAlert(of: alertType)
            }
        }
    }

    private func removeAllSections() {
        children.forEach { section in
            section.removeFromParent()
        }
    }

    private func addSections(feedData: FeedData) {
        // Initalise new Carousel View Controller for each section
        feedData.sections.forEach({ section in
            // Init new Carousel View Controller
            let carouselViewController = CarouselViewController()
            // Init new Carousel View Model, and assign it to Carousel View Controller
            let carouselViewModel = CarouselViewModel(sectionData: section)
            carouselViewController.viewModel = carouselViewModel
            // Add Carousel View Controller as Child
            self.addChild(carouselViewController)
            carouselViewController.didMove(toParent: self)
            // Add Carouse View to Stack View
            self.stackView.addArrangedSubview(carouselViewController.view)
        })
    }

    // TODO: - Move setup views into lazy variables

    private func setupViews() {
        // Customise view
        view.backgroundColor = .white

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

        updateViewConstraints()
    }

    // MARK: -

    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String

        switch alertType {
        case .noFeedDataAvailable:
            title = "Unable to Fetch Feed Data"
            message = "The application is unable to fetch manga data. Please make sure your device is connected over Wi-Fi or cellular."
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

    public func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
