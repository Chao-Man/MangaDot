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
        addChildViewControllers()
        setInitialViewController()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reenableSwipeBack()
        super.viewDidAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    // MARK: - Helper Methods
    
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
            let readerChapterViewController = ReaderChapterCollectionViewController(viewModel: readerChapterViewModel, shouldPreload: true)
            pageViewController.setViewControllers([readerChapterViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
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
    
    func reenableSwipeBack() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

extension ReaderViewController: UIPageViewControllerDelegate {
    
}

extension ReaderViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        do {
            let viewController = viewController as! ReaderChapterCollectionViewController
            let readerChapterViewModel = try viewModel.chapter(beforeIndex: viewController.index())
            return ReaderChapterCollectionViewController(viewModel: readerChapterViewModel, shouldPreload: false)
        } catch {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        do {
            let viewController = viewController as! ReaderChapterCollectionViewController
            let readerChapterViewModel = try viewModel.chapter(afterIndex: viewController.index())
            return ReaderChapterCollectionViewController(viewModel: readerChapterViewModel, shouldPreload: true)
        } catch {
            return nil
        }
    }
}
