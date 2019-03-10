//
//  TitleInfoControllerView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import PromiseKit
import UIKit
import Yalta
import SwiftIcons

class TitleInfoSideBarViewController: UIViewController {
    // MARK: - Instance Properties

    private let viewModel: TitleInfoViewModel
    private let containerInset: CGFloat = 15
    private let navigationViewHeight: CGFloat = 65
    private lazy var scrollViewInset: CGFloat = navigationViewHeight - 10

    // MARK: - Computed Instance Properties

    let coverView = ShadowCoverView()
    
    lazy var containerStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: containerInset, bottom: containerInset, right: containerInset)
        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let navigationView = LightTranslucentView()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("TitleInfo.button.back".localized(), for: .normal)
        button.setTitleColor(MangaDot.Color.pink, for: .normal)
        let size = CGSize(width: 30, height: 30)
        let image = UIImage(icon: FontType.ionicons(.iosArrowBack), size: size, textColor: MangaDot.Color.pink, backgroundColor: .clear)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: scrollViewInset, left: 0, bottom: 0, right: 0)
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.always
        return scrollView
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.mediumLarge
        label.textColor = UIColor.black
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let descriptionView: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.regularSmall
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let authorsContainer = UIView()
    private let artistsContainer = UIView()

    private let authorView = TagListView()
    private let artistView = TagListView()
    private let genreView = TagListView()
    
    private lazy var authorLabel = makeSectionLabel(withText: "TitleInfo.label.author".localized())
    private lazy var artistLabel = makeSectionLabel(withText: "TitleInfo.label.artist".localized())
    private lazy var genreLabel = makeSectionLabel(withText: "TitleInfo.label.tags".localized())

    // MARK: - Life Cycle

    init(viewModel: TitleInfoViewModel, placeholder: UIImage?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.coverView.imageView.image = placeholder
        setViewsTransparent()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        view.layer.shadowColor = MangaDot.Color.gray.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 5
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Methods
    
    func loadContent() {
        loadCover()
        titleView.text = viewModel.title()
        descriptionView.text = viewModel.description()
        authorView.addTags(withTextList: viewModel.author())
        artistView.addTags(withTextList: viewModel.artist())
        genreView.addTags(withTextList: viewModel.genre())
        fadeInViews()
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods

    private func setupViews() {
        let widthConstraint = scrollView.al.width - (containerInset * 2)
        view.backgroundColor = MangaDot.Color.white
        
        view.addSubview(scrollView) {
            $0.top.pinToSuperview()
            $0.bottom.pinToSuperviewMargin()
            $0.edges(.left, .right).pinToSuperview()
        }
        
        view.addSubview(navigationView) {
            $0.edges(.top, .left, .right).pinToSuperview()
            $0.height.set(navigationViewHeight)
        }
        
        navigationView.addSubview(backButton) {
            $0.top.pinToSuperviewMargin()
            $0.left.pinToSuperviewMargin()
        }
        
        scrollView.addSubview(containerStackview) {
            $0.edges.pinToSuperview()
            $0.width.match(scrollView.al.width)
        }
        containerStackview.addArrangedSubview(coverView) {
            $0.width.match(widthConstraint)
            $0.height.match(widthConstraint * 1.422222222)
        }
        containerStackview.addArrangedSubview(titleView) {
            $0.width.match(widthConstraint)
        }
        containerStackview.addArrangedSubview(descriptionView) {
            $0.width.match(widthConstraint)
        }
        containerStackview.addArrangedSubview(SeparatorView(axis: .horizontal)) {
            $0.width.match(widthConstraint)
            $0.height.set(1)
        }
        containerStackview.addArrangedSubview(creatorsContainer) {
            $0.width.match(widthConstraint)
        }
        creatorsContainer.addArrangedSubview(authorsContainer)
        creatorsContainer.addArrangedSubview(artistsContainer)
        authorsContainer.addSubview(authorLabel, authorView) {
            $0.edges(.left, .top, .right).pinToSuperview()
            $1.top.align(with: $0.bottom + 10)
            $1.edges(.left, .bottom, .right).pinToSuperview()
        }
        artistsContainer.addSubview(artistLabel, artistView) {
            $0.edges(.left, .top, .right).pinToSuperview()
            $1.top.align(with: $0.bottom + 10)
            $1.edges(.left, .bottom, .right).pinToSuperview()
        }
        containerStackview.addArrangedSubview(SeparatorView(axis: .horizontal)) {
            $0.width.match(widthConstraint)
            $0.height.set(8)
        }
        containerStackview.addArrangedSubview(genreLabel, genreView) {
            $0.width.match(widthConstraint)
            $1.width.match(widthConstraint)
        }
    }

    private func loadCover() {
        firstly {
            try viewModel.fetchLargeCover(imageView: coverView.imageView, placeholderImage: coverView.imageView.image)
        }.catch { error in
            print(error)
        }
    }
    
    private func setViewsTransparent() {
        titleView.alpha = 0.0
        descriptionView.alpha = 0.0
        creatorsContainer.alpha = 0.0
        genreLabel.alpha = 0.0
        genreView.alpha = 0.0
    }
    
    private func fadeInViews() {
        UIView.animate(withDuration: 0.8) {
            self.titleView.alpha = 1.0
            self.descriptionView.alpha = 1.0
            self.creatorsContainer.alpha = 1.0
            self.genreLabel.alpha = 1.0
            self.genreView.alpha = 1.0
        }
    }

    private func makeSectionLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = MangaDot.Font.mediumSmall
        label.textColor = MangaDot.Color.black
        label.text = text
        return label
    }
}
