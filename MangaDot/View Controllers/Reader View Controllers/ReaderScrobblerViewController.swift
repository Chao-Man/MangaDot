//
//  ReaderScrobblerViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 18/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import SnapKit
import UIKit
import Kingfisher

class ReaderScrobblerViewController: UIViewController {
    // MARK: - Types

    // MARK: - Properties

    let separatorView = SeparatorView(axis: .horizontal, width: 0.5, inset: 0, color: UIColor.gray)
    let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionViewController: UICollectionViewController = {
        let viewController = UICollectionViewController(collectionViewLayout: layout)
        viewController.collectionView.backgroundColor = .clear
        viewController.collectionView.delegate = self
        viewController.collectionView.dataSource = self
        viewController.collectionView.register(ReaderScrobblerCell.self, forCellWithReuseIdentifier: "ScrobblerCell")
        viewController.willMove(toParent: self)
        addChild(viewController)
        return viewController
    }()

    private lazy var visualEffectsView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: visualEffect)
        view.clipsToBounds = true
        view.contentView.addSubview(collectionViewController.view)
        view.contentView.addSubview(separatorView)
        return view
    }()

    var viewModel: ScrobblerViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                reload()
                return
            }
            loadData(with: viewModel)
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        setupViews()
        super.viewDidLoad()
    }

    override func updateViewConstraints() {
        visualEffectsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }

        super.updateViewConstraints()
    }

    // MARK: - Helper Methods

    private func setupViews() {
        view.addSubview(visualEffectsView)
        updateViewConstraints()
    }

    private func loadData(with _: ScrobblerViewModel) {
        collectionViewController.collectionView.reloadData()
    }
    
    // MARK: - Methods
    
    func reload() {
        collectionViewController.collectionView.reloadData()
    }
}

extension ReaderScrobblerViewController: UICollectionViewDelegate {}

extension ReaderScrobblerViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let pageCount = viewModel?.numberOfPages() else { return 0 }
        return pageCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        guard let imageUrl = viewModel.pageImageUrl(index: indexPath.item) else { return UICollectionViewCell() }
        guard let scrobblerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ScrobblerCell",
            for: indexPath
        ) as? ReaderScrobblerCell else {
            return ReaderScrobblerCell()
        }

        scrobblerCell.recycle(imageUrl: imageUrl)
        return scrobblerCell
    }
}

extension ReaderScrobblerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.bounds.height - (layout.sectionInset.top + layout.sectionInset.bottom)
        let width: CGFloat = 150
        
        let defaultSize = CGSize(
            width: width,
            height: height
        )
        
        return defaultSize
//        guard let viewModel = viewModel else {
//            return defaultSize
//        }
//        guard let imageUrl = viewModel.pageImageUrl(index: indexPath.item) else
//        {
//            return defaultSize
//        }
        
    }
}
