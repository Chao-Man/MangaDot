//
//  FeedViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import PromiseKit
import SwiftDate
import UIKit
import Yalta

class FeedViewController: UIViewController, CarouselParent {
    // MARK: - Instance Properties

    private var sections: [CarouselViewController] = []
    private lazy var source = Current.sources.getDefault()
    private lazy var viewModel = FeedViewModel(source)
    var selectedCell: CarouselCell?

    // MARK: - Computed Instance Properties

    private lazy var stackView: UIStackView = {
        let stackView = SeparatedStackView(inset: 45)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Feed.updating".localized())
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    private lazy var largeTitleView: LargeTitleView = {
        let view = LargeTitleView()
        view.titleLabel.text = "FeedViewController.title".localized()
        view.subtitleLabel.text = Current.date().toFormat("EEEE, d MMMM").uppercased()
        return view
    }()
    
    var currentView: UIView {
        get {
            return self.view
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        refreshFeed()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Helper Methods

    private func setupViews() {
        view.backgroundColor = MangaDot.Color.white
        scrollView.refreshControl = refreshControl

        view.addSubview(scrollView) {
            $0.edges.pinToSafeArea(of: self)
        }

        scrollView.addSubview(stackView) {
            $0.edges.pinToSuperview()
            $0.width.match(scrollView.al.width)
        }
    }

    private func addLargeTitleView() {
        stackView.addArrangedSubview(largeTitleView) {
            $0.width.match(stackView.al.width)
        }
    }

    private func refreshFeed() {
        firstly {
            viewModel.fetchFeed()
        }.done { [weak self] _ in
            self?.refreshContent()
        }.catch { [weak self] error in
            self?.present(UIAlertController.MangaDot.errorAlert(of: error), animated: true)
            print(error)
        }.finally {
            self.refreshControl.endRefreshing()
        }
    }

    private func refreshContent() {
        clearSections()
        addLargeTitleView()
        viewModel.sections().forEach {
            addSection(section: $0)
        }
    }

    private func addSection(section: SectionProtocol) {
        if !(section.isEmpty()) {
            let carouselViewController = CarouselViewController(data: section, source: source)
            sections.append(carouselViewController)
            addChild(carouselViewController)
            carouselViewController.didMove(toParent: self)
            stackView.addArrangedSubview(carouselViewController.view)
        }
    }

    private func clearSections() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        sections.forEach {
            $0.removeFromParent()
        }
        sections = []
    }

    @objc private func handleRefresh() {
        refreshFeed()
    }
}
