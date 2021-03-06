//
//  ReaderViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 28/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import PromiseKit

class ReaderViewController: UIViewController {
    private let viewModel: ReaderViewModel
    
    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(
            transitionStyle: UIPageViewController.TransitionStyle.scroll,
            navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
            options: nil)
        viewController.delegate = self
        viewController.dataSource = self
        viewController.view.backgroundColor = MangaDot.Color.white
        return viewController
    }()
    
    private let startingChapterIndex: Int
    
    init(selectedIndex: Int, viewModel: ReaderViewModel) {
        self.viewModel = viewModel
        self.startingChapterIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        setup()
        addChildViewControllers()
        setInitialViewController()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTabBarHidden(true)
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        setTabBarHidden(false)
        tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return navigationController?.isNavigationBarHidden == true
//    }
//    
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return UIStatusBarAnimation.fade
//    }

    // MARK: - Helper Methods
    
    private func setup() {
    }
    
    private func addChildViewControllers() {
        pageViewController.willMove(toParent: self)
        addChild(pageViewController)
        
        view.addSubview(pageViewController.view) {
            $0.edges.pinToSuperview()
        }
    }
    
    private func setInitialViewController() {
        do {
            let readerChapterViewModel = try viewModel.chapter(withIndex: startingChapterIndex)
            let readerChapterViewController = ReaderChapterViewController(viewModel: readerChapterViewModel, shouldPreload: true)
            pageViewController.setViewControllers([readerChapterViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        } catch {
            
        }
    }
    
    @objc private func handleButton() {
//        viewModel.pageImageUrl(atChapterIndex: 0, atPageIndex: 0).done {
//            if let url = $0 {
//                print(url)
//            }
//        }
    }
}

extension ReaderViewController: UIPageViewControllerDelegate {
    
}

extension ReaderViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("Fetching Prev Chapter")
        do {
            let viewController = viewController as! ReaderChapterViewController
            let readerChapterViewModel = try viewModel.chapter(beforeIndex: viewController.index())
            return ReaderChapterViewController(viewModel: readerChapterViewModel, shouldPreload: false)
        } catch {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("Fetching Next Chapter")
        do {
            let viewController = viewController as! ReaderChapterViewController
            let readerChapterViewModel = try viewModel.chapter(afterIndex: viewController.index())
            return ReaderChapterViewController(viewModel: readerChapterViewModel, shouldPreload: true)
        } catch {
            return nil
        }
    }
}
