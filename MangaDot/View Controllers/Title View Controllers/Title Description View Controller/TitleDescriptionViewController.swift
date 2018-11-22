//
//  TitleDescriptionViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class TitleDescriptionViewController: PalettableViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let containerView = UIView()
    let coverView = CoverView()
    let titleView = UILabel()
    let creatorsContainerView = UIView()
    let authorHeaderView = UILabel()
    let artistHeaderView = UILabel()
    let authorView = UILabel()
    let artistView = UILabel()
    let descriptionView = UILabel()
    let descriptionStyle = NSMutableParagraphStyle()

    var viewModel: TitleDescriptionViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            loadData(with: viewModel)
        }
    }

    // MARK: - View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        applyPalette(palette: palette)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        applyPalette(palette: MangaDot.Pallete.lightTheme)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        updateViewConstraints()
    }

    override func updateViewConstraints() {
        // ScrollView Constraints
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.width.equalToSuperview()
        }

        // ContainerView Constraints
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
        }

        // CoverContainer Constraints
        coverView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.height
                .equalTo(coverView.snp.width)
                .multipliedBy(1.4222)
        }

        titleView.snp.makeConstraints { make in
            make.top
                .equalTo(coverView.snp.bottom).offset(10)
            make.left
                .equalTo(coverView)
            make.width
                .equalTo(coverView)
        }

        descriptionView.snp.makeConstraints { make in
            make.top
                .equalTo(titleView.snp.bottom)
                .offset(5)
            make.left
                .equalTo(titleView)
            make.width
                .equalTo(coverView)
            make.bottom
                .equalToSuperview().offset(-20)
        }

        titleView.sizeToFit()
        descriptionView.sizeToFit()
        super.updateViewConstraints()
    }

    // MARK: - Helper Methods

    private func setupViews() {
        // Customise view
        view.backgroundColor = .white

        // Init sub views
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(coverView)
        containerView.addSubview(titleView)
        containerView.addSubview(creatorsContainerView)
        containerView.addSubview(descriptionView)

        // Setup ScrollView
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        // Setup TitleView
        titleView.font = UIFont.MangaDot.boldLarge
        titleView.numberOfLines = 3

        // Setup DescriptionView
        descriptionView.font = UIFont.MangaDot.regularSmall
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.numberOfLines = 5

        // Setup Description Style
        descriptionStyle.lineSpacing = 1.4
        descriptionStyle.lineBreakMode = .byTruncatingTail
    }

    private func loadData(with viewModel: TitleDescriptionViewModel) {
        titleView.text = viewModel.title
        setDescription(description: viewModel.description)
        loadImage(coverUrl: viewModel.coverUrl, largeCoverUrl: viewModel.largeCoverUrl)
    }

    private func setDescription(description: String?) {
        guard let description = description else {
            return
        }

        let attrString = NSMutableAttributedString(string: description)
        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: descriptionStyle,
            range: NSMakeRange(
                0,
                attrString.length
            )
        )
        descriptionView.attributedText = attrString
    }

    private func loadImage(coverUrl: URL, largeCoverUrl: URL?) {
//        let setupColorTheme: (UIImage?, NSError?, CacheType, URL?) -> Void = {
//            [weak self] (image: UIImage?, _: NSError?, _: CacheType, _: URL?) in
//            if let image = image {
//                image.getColors { colors in
//                    self?.palette = ColorPalette(colors: colors)
//                }
//            }
//        }

        if let largeCoverUrl = largeCoverUrl {
            coverView.kf.setImage(with: largeCoverUrl, options: [.transition(.fade(0.2)), .waitForCache])
        } else {
            coverView.kf.setImage(with: coverUrl, options: [.transition(.fade(0.2)), .waitForCache])
        }
    }
}
