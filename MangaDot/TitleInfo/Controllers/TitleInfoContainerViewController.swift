//
//  TitleInfoContainerViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 10/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import PromiseKit
import UIKit
import Yalta

class TitleInfoContainerViewController: UIViewController {
    // MARK: - Types

    // MARK: - Instance Properties

    private var viewModel: TitleInfoViewModel
    private lazy var refresh: () -> Void = {
        self.reloadContent()
    }
    private let placeholder: UIImage?
    
    var swipeInteractionController: SwipeInteractionController?
    
    var titleInfoSideBarViewController: TitleInfoSideBarViewController
    var titleInfoMainViewController: TitleInfoMainViewController

    // MARK: - Computed Instance Properties

    // MARK: - View Life Cycle

    init(id: Int, source: SourceProtocol, placeholder: UIImage? = UIImage()) {
        self.placeholder = placeholder
        viewModel = TitleInfoViewModel(id: id, source: source)
        titleInfoSideBarViewController = TitleInfoSideBarViewController(viewModel: viewModel, placeholder: placeholder)
        titleInfoMainViewController = TitleInfoMainViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper Methods
    
    private func fetchData() {
        firstly {
            viewModel.fetch()
        }.done {
            self.loadChildViewControllerContent()
        }.catch { error in
            print(error)
        }
    }
    
    private func setup() {
        swipeInteractionController = SwipeInteractionController(viewController: self)
        setupViews()
        addChildViewControllers()
        fetchData()
    }

    private func setupViews() {
        view.backgroundColor = MangaDot.Color.white
        view.isOpaque = true
    }
    
    private func reloadContent() {
        removeChildViewControllers()
        titleInfoSideBarViewController = TitleInfoSideBarViewController(viewModel: viewModel, placeholder: placeholder)
        titleInfoMainViewController = TitleInfoMainViewController(viewModel: viewModel)
        addChildViewControllers()
        fetchData()
    }
    
    private func addChildViewControllers() {
        titleInfoSideBarViewController.willMove(toParent: self)
        addChild(titleInfoSideBarViewController)
        titleInfoMainViewController.willMove(toParent: self)
        addChild(titleInfoMainViewController)
        addViews(titleInfoSideView: titleInfoSideBarViewController.view, titleInfoMainView: titleInfoMainViewController.view)
    }

    private func removeChildViewControllers() {
        titleInfoSideBarViewController.view.removeFromSuperview()
        titleInfoSideBarViewController.removeFromParent()
        
        titleInfoMainViewController.view.removeFromSuperview()
        titleInfoMainViewController.removeFromParent()
    }

    private func addViews(titleInfoSideView: UIView, titleInfoMainView: UIView) {
        view.addSubview(titleInfoMainView, titleInfoSideView) {
            $1.edges(.left, .bottom).pinToSafeArea(of: self)
            $1.top.pinToSuperview()
            $1.width.match(view.al.width * 0.35)
            $0.left.align(with: $1.right)
            $0.edges(.right, .bottom).pinToSafeArea(of: self)
            $0.top.pinToSuperview()
        }
    }
    
    private func loadChildViewControllerContent() {
        titleInfoSideBarViewController.loadContent()
        titleInfoMainViewController.loadContent()
    }
    
    func handleClose() {
        navigationController?.popViewController(animated: true)
    }
}
