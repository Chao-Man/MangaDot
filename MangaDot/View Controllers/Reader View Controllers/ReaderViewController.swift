//
//  ReaderViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import Kingfisher

class ReaderViewController: UIPageViewController {
    // MARK: - Types

    private enum AlertType {
        case noPageDataAvailable
    }

    // MARK: - Properties

    var pages: [ReaderPageViewController] = []
    
    var viewModel: ReaderViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            loadData(with: viewModel)
            viewModel.fetchPagesData()
        }
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnTap = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnTap = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Helper Methods

    private func loadData(with viewModel: ReaderViewModel) {
        viewModel.didFetchChapterPageData = { [weak self] pageData, error in
            if let _ = error {
                self?.presentAlert(of: .noPageDataAvailable)
            } else if let pageData = pageData {
                self?.setupPages(pageData: pageData)
            }
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        dataSource = self
    }

    private func setupPages(pageData: ChapterPageData) {
        // Prefetch URLs
        let pageUrls = pageData.pageUrlArray.compactMap({ $0 })
        ImagePrefetcher.init(urls: pageUrls).start()
        
        pageData.pageUrlArray.forEach { pageUrl in
            if let pageUrl = pageUrl {
                pages.append(ReaderPageViewController(imageUrl: pageUrl))
            }
        }
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }

    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String

        switch alertType {
        case .noPageDataAvailable:
            title = "Unable to Fetch Chapter Page Data"
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
}

extension ReaderViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageViewController = viewController as? ReaderPageViewController else { return nil }
        guard let pageIndex = pages.index(of: pageViewController) else { return nil }
        
        let previousPageIndex = pageIndex - 1
        
        guard previousPageIndex >= 0 else { return nil }
        guard previousPageIndex < pages.count else { return nil }
        
        return pages[previousPageIndex]
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageViewController = viewController as? ReaderPageViewController else { return nil }
        guard let pageIndex = pages.index(of: pageViewController) else { return nil }
        
        let previousPageIndex = pageIndex + 1
        
        guard previousPageIndex >= 0 else { return nil }
        guard previousPageIndex < pages.count else { return nil }
        
        return pages[previousPageIndex]
    }
}


extension ReaderViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
