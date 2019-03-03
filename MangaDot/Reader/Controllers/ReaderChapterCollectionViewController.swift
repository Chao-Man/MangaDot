//
//  ReaderChapterCollectionViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 28/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import PromiseKit
import Nuke

class ReaderChapterCollectionViewController: UIViewController {
    private let viewModel: ReaderChapterViewModel
    private let reuseIdentifier = "ReaderPageCell"
    private let shouldPreload: Bool
    lazy var readerPageCellSize: CGSize = view.frame.size
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.bounds.size
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReaderPageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        collectionView.backgroundColor = MangaDot.Color.white
        return collectionView
    }()
    
    init(viewModel: ReaderChapterViewModel, shouldPreload: Bool) {
        self.viewModel = viewModel
        self.shouldPreload = shouldPreload
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        addViews()
        setup()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopPreloading()
        super.viewWillDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.itemSize = collectionView.frame.size
        adjustContentOffset()
    }
    
    // MARK: - Helper Methods
    
    private func setup() {
        firstly {
            viewModel.fetch()
        }.done {
            self.reloadData()
            if (self.shouldPreload) {
                self.viewModel.startPreloading()
            }
        }
    }
    
    private func addViews() {
        view.addSubview(collectionView) {
            $0.edges.pinToSuperview()
        }
    }
    
    private func reloadData() {
        collectionView.reloadData()
    }
    
    private func adjustContentOffset() {
        guard let currentCellIndexPath = collectionView.indexPathsForVisibleItems.last else { return }
        collectionView.scrollToItem(at: currentCellIndexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
    
    // MARK: - Methods
    
    func index() -> Int {
        return viewModel.index
    }
}

extension ReaderChapterCollectionViewController: UICollectionViewDelegate {
    
}

extension ReaderChapterCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let readerPageCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReaderPageCell
        readerPageCell.imageView.image = nil
        guard let imageUrl = viewModel.pageImageUrl(atIndex: indexPath.item) else {
            return readerPageCell
        }
        
        Nuke.loadImage(
            with: imageUrl,
            options: ImageLoadingOptions(
                transition: .fadeIn(duration: 0.33)
            ),
            into: readerPageCell.imageView
        )
        
        return readerPageCell
    }
}
