//
//  ReaderScrobblerViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 18/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import Nuke

class ReaderScrobblerViewController: UIViewController {
    // MARK: - Types
    
    // MARK: - Properties
    var viewModel: ReaderChapterViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    private let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    private let reuseIdentifier = "ScrobblerCell"
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(ReaderScrobblerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var visualEffectsView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: visualEffect)
        return view
    }()
    
    
    // MARK: - View Life Cycle
    
    init(viewModel: ReaderChapterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setup()
        setupViews()
        super.viewDidLoad()
    }
    
    // MARK: - Helper Methods
    
    private func setup() {
        
    }
    
    private func setupViews() {
        view.addSubview(visualEffectsView) {
            $0.edges.pinToSuperview()
        }
        
        view.addSubview(collectionView) {
            $0.edges.pinToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension ReaderScrobblerViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ReaderScrobblerViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.pageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReaderScrobblerCell
        cell.imageView.image = nil
        guard let viewModel = viewModel else { return cell }
        guard let imageUrl = viewModel.pageImageUrl(atIndex: indexPath.item) else {
            return cell
        }
        
        cell.activityView.startAnimating()
        
        Nuke.loadImage(
            with: imageUrl,
            options: ImageLoadingOptions(
                transition: .fadeIn(duration: 0.33)
            ),
            into: cell.imageView,
            completion: { (response, error) in
                cell.activityView.stopAnimating()
            }
        )
        
        return cell
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
    }
}
