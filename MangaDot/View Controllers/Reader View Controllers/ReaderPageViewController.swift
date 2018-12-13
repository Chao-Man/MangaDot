//
//  ReaderViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import SnapKit
import UIKit

class ReaderPageViewController: UIPageViewController {
    // MARK: - Types

    private enum AlertType {
        case noPageDataAvailable
    }

    // MARK: - Properties

    var viewModel: ReaderViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            loadData(with: viewModel)
            viewModel.reload()
        }
    }

    var disableTaps: Bool = false

    private var pendingViewController: ReaderPageContentViewController?
    private var currentViewController: ReaderPageContentViewController? {
        didSet {
            guard let currentViewController = currentViewController else { return }
            guard let chapter = viewModel?.getChapter(withPageUrl: currentViewController.imageUrl) else { return }
            title = "Chapter: \(chapter.chapter)"
            loadScrobblerData(chapter: chapter)
        }
    }

    let pageScrobbler = ReaderScrobblerViewController()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        pageScrobbler.view.isHidden = true
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }

    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }

    override func updateViewConstraints() {
        pageScrobbler.view.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        super.updateViewConstraints()
    }

    // MARK: - Helper Methods

    private func loadData(with viewModel: ReaderViewModel) {
        viewModel.didReloadChapterPages = { [weak self] error in
            if let _ = error {
                self?.presentAlert(of: .noPageDataAvailable)
            } else {
                self?.setupPages()
            }
        }
    }

    private func setupViewControllers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        pageScrobbler.willMove(toParent: self)
        addChild(pageScrobbler)
        view.addSubview(pageScrobbler.view)
    }

    private func setup() {
        view.backgroundColor = .white
        delegate = self
        dataSource = self
    }

    private func setCurrentPage(pageUrl: URL, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool = false) {
        currentViewController = ReaderPageContentViewController(imageUrl: pageUrl)
        setViewControllers([currentViewController!], direction: direction, animated: animated, completion: nil)
    }

    private func setupPages() {
        guard let firstPageUrl = viewModel?.firstPageUrl() else { return }
        setCurrentPage(pageUrl: firstPageUrl)
    }

    private func clearScrobblerData() {
        pageScrobbler.viewModel = nil
    }

    private func loadScrobblerData(chapter: ChapterPageData) {
        var scrobblerViewModel = ScrobblerViewModel(chapterData: chapter)
        scrobblerViewModel.didSelectCell = { [weak self] index in
            self?.goToPage(with: index)
        }
        pageScrobbler.viewModel = scrobblerViewModel
    }

    private func refreshDatasource() {
        // Refresh datasource, new page available
        dataSource = nil
        dataSource = self
    }

    private func getPageUrl(from viewController: UIViewController) -> URL? {
        guard let pageContentViewController = viewController as? ReaderPageContentViewController else { return nil }
        return pageContentViewController.imageUrl
    }

    private func goToPage(with index: Int) {
        guard let viewModel = viewModel else { return }
        guard let pageUrl = viewModel.getPageWith(index: index) else { return }

        setCurrentPage(pageUrl: pageUrl)
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

extension ReaderPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPageUrl = getPageUrl(from: viewController) else { return nil }
        guard let prevPageUrl = viewModel?.prevPageUrl(currentPageUrl: currentPageUrl) else { return nil }
        return ReaderPageContentViewController(imageUrl: prevPageUrl)
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentPageUrl = getPageUrl(from: viewController) else { return nil }
        guard let nextPageUrl = viewModel?.nextPageUrl(currentPageUrl: currentPageUrl) else { return nil }
        return ReaderPageContentViewController(imageUrl: nextPageUrl)
    }
}

extension ReaderPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // Update current view controller
            if let previousViewController = previousViewControllers.first {
                if currentViewController == previousViewController {
                    currentViewController = pendingViewController
                }
            }
            // Remove unused views, let ARC remove from memory
            previousViewControllers.forEach { viewController in
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        }
    }

    func pageViewController(_: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let pendingViewController = pendingViewControllers.first {
            self.pendingViewController = pendingViewController as? ReaderPageContentViewController
        }
    }
}

extension ReaderPageViewController: UIGestureRecognizerDelegate {
    private func showPageScrobbler() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        pageScrobbler.view.isHidden = false

        let originalPoint = pageScrobbler.view.center
        let startPoint = CGPoint(
            x: pageScrobbler.view.center.x,
            y: pageScrobbler.view.center.y + pageScrobbler.view.frame.size.height
        )

        pageScrobbler.view.center = startPoint

        UIView.animate(withDuration: 0.2, animations: {
            self.pageScrobbler.view.center = originalPoint
            self.disableTaps = false
        })
    }

    private func hidePageScrobbler() {
        navigationController?.setNavigationBarHidden(true, animated: true)

        let originalPoint = pageScrobbler.view.center
        let endPoint = CGPoint(
            x: pageScrobbler.view.center.x,
            y: pageScrobbler.view.center.y + pageScrobbler.view.frame.size.height
        )
        UIView.animate(withDuration: 0.2, animations: {
            self.pageScrobbler.view.center = endPoint

        }) { _ in
            self.pageScrobbler.view.isHidden = true
            self.pageScrobbler.view.center = originalPoint
            self.disableTaps = false
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        guard sender.view != pageScrobbler else { return }

        disableTaps = true

        if pageScrobbler.view.isHidden {
            pageScrobbler.reload()
            showPageScrobbler()
        } else {
            hidePageScrobbler()
        }
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return false
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Ignore tap if currently animating
        if disableTaps { return false }
        guard let touchView = touch.view else { return false }
        if touchView.isDescendant(of: pageScrobbler.view) { return false }
        return true
    }
}
