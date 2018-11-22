//
//  CarouselViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class CarouselViewController: UIViewController {
    // MARK: - Properties

    var viewModel: CarouselViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            // Setup View Model
            setupViewModel(with: viewModel)
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupViewModel(with _: CarouselViewModel) {}

    // MARK: - Helper Methods

    private func setupViews() {
        // Initalise collection layout
        let layout = UICollectionViewFlowLayout()

        // Initialise views
        let headerView = UILabel()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)

        // Add Subviews
        view.addSubview(headerView)
        view.addSubview(collectionView)

        // Setup Layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 135, height: 216)
        layout.scrollDirection = .horizontal

        // Setup View
        view.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(layout.itemSize.height + 70)
        }

        // Setup Header View
        headerView.text = viewModel?.sectionName().localized()
        headerView.font = UIFont.MangaDot.boldLarge

        // Setup Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self

        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white

        // Setup Header View Constraints
        headerView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }

        // Setup Collection View Constraints
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }

    // MARK: - Delegate Methods
}

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        return viewModel.numberOfTitles()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let carouselCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CarouselCell",
            for: indexPath
        ) as? CarouselCell else {
            let carouselCell = CarouselCell()
            carouselCell.recycle(titleData: viewModel!.titleData(index: indexPath.row))
            return carouselCell
        }

        carouselCell.recycle(titleData: viewModel!.titleData(index: indexPath.row))
        return carouselCell
    }
}

extension CarouselViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            // No View Model
            return
        }

        guard let id = viewModel.sectionData.titleList[indexPath.row].id else {
            // Row doesn't exist
            return
        }

        let title = viewModel.sectionData.titleList[indexPath.row].title

        let titleViewController = TitleViewController()
        let titleViewModel = TitleViewModel(titleId: id)
        titleViewController.viewModel = titleViewModel
        titleViewController.title = title
        navigationController?.pushViewController(titleViewController, animated: true)
    }

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        if let carouselCell = cell as? CarouselCell {
            carouselCell.coverView.kf.cancelDownloadTask()
        }
    }
}

extension CarouselViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var coverUrls: [URL] = []
        let smallCoverUrls = indexPaths.compactMap { (indexPath) -> URL? in
            guard let coverUrl = self.viewModel?.titleData(index: indexPath.item).coverUrl else { return nil }
            guard ImageCache.default.imageCachedType(forKey: coverUrl.absoluteString) == .none else { return nil }
            return coverUrl
        }
        let largeCoverUrls = indexPaths.compactMap { (indexPath) -> URL? in
            guard let coverUrl = self.viewModel?.titleData(index: indexPath.item).largeCoverUrl else { return nil }
            guard ImageCache.default.imageCachedType(forKey: coverUrl.absoluteString) == .none else { return nil }
            return coverUrl
        }
        coverUrls += smallCoverUrls
        coverUrls += largeCoverUrls
        let imagePrefetcher = ImagePrefetcher(urls: coverUrls)
        imagePrefetcher.maxConcurrentDownloads = 1
        imagePrefetcher.start()
    }
}
