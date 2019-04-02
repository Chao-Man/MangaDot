//
//  LibraryViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class LibraryViewController: UIViewController {
//    // MARK: - Instance Properties
//    
//    private var sections: [CarouselViewController] = []
//    private lazy var viewModel = LibraryViewModel()
//    
//    // MARK: - Computed Instance Properties
//    
//    private let stackView: UIStackView = {
//        let stackView = SeparatedStackView(inset: 45)
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 0
//        return stackView
//    }()
//    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.alwaysBounceVertical = true
//        return scrollView
//    }()
//    
//    private let refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Feed.updating".localized())
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        return refreshControl
//    }()
//    
//    private let largeTitleView: LargeTitleView = {
//        let view = LargeTitleView()
//        view.titleLabel.text = "FeedViewController.title".localized()
//        view.subtitleLabel.text = Current.date().toFormat("EEEE, d MMMM").uppercased()
//        return view
//    }()
//    
//    private let errorView = UIView()
//    private let errorImageView: UIImageView = {
//        let imageView = UIImageView()
//        let size = CGSize(width: 100, height: 100)
//        imageView.contentMode = .center
//        imageView.setIcon(icon: .dripicon(.wrong),
//                          textColor: MangaDot.Color.gray,
//                          backgroundColor: MangaDot.Color.white,
//                          size: size)
//        return imageView
//    }()
//    private let errorLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Library.Error.refresh".localized()
//        label.font = MangaDot.Font.mediumSmall
//        label.textColor = MangaDot.Color.gray
//        label.textAlignment = .center
//        return label
//    }()
//    
//    // MARK: - View Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        refreshFeed()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        setNavigationBarTransparent()
//        super.viewWillAppear(animated)
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func setupViews() {
//        view.backgroundColor = MangaDot.Color.white
//        scrollView.refreshControl = refreshControl
//        
//        view.addSubview(scrollView) {
//            $0.edges.pinToSafeArea(of: self)
//        }
//        
//        scrollView.addSubview(stackView) {
//            $0.edges.pinToSuperview()
//            $0.width.match(scrollView.al.width)
//        }
//        
//        scrollView.addSubview(errorView) {
//            $0.height.match(scrollView.al.height * 0.25)
//            $0.width.match(scrollView.al.width * 0.25)
//            $0.center.align(with: scrollView.al.center)
//        }
//        
//        errorView.addSubview(errorImageView, errorLabel) {
//            $0.edges(.left, .right, .top).pinToSuperview()
//            $1.edges(.left, .right, .bottom).pinToSuperview()
//            $1.top.align(with: $0.bottom)
//            $0.height.match(errorView.al.height * 0.75)
//        }
//        
//        errorView.isHidden = true
//        addLargeTitleView()
//    }
//    
//    private func setNavigationBarTransparent() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        self.navigationItem.title = nil
//    }
//    
//    private func addLargeTitleView() {
//        stackView.addArrangedSubview(largeTitleView) {
//            $0.width.match(stackView.al.width)
//        }
//    }
//    
//    private func refreshFeed() {
//        
//    }
//    
//    private func refreshContent() {
//        clearSections()
//        addLargeTitleView()
//        viewModel.sections().forEach {
//            addSection(section: $0)
//        }
//    }
//    
//    private func addSection(section: SectionProtocol) {
//        if !(section.isEmpty()) {
//            let carouselViewController = CarouselViewController(data: section, source: source)
//            sections.append(carouselViewController)
//            addChild(carouselViewController)
//            stackView.addArrangedSubview(carouselViewController.view)
//            carouselViewController.didMove(toParent: self)
//        }
//    }
//    
//    private func clearSections() {
//        stackView.arrangedSubviews.forEach {
//            $0.removeFromSuperview()
//        }
//        sections.forEach {
//            $0.removeFromParent()
//        }
//        sections = []
//    }
//    
//    @objc private func handleRefresh() {
//        refreshFeed()
//    }
}
