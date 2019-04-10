//
//  ReaderChapterViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 28/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import PromiseKit
import Nuke

class ReaderChapterViewController: UIViewController {
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
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gesture.delegate = self
        return gesture
    }()
    
    lazy var scrobblerViewController: ReaderScrobblerViewController = {
        let viewController = ReaderScrobblerViewController(viewModel: viewModel)
        viewController.view.isHidden = true
        return viewController
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
        addChildViewController()
        setup()
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopPreloading()
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.itemSize = collectionView.frame.size
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update collectionview offset to align page after orientation change
        guard let currentCellIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        collectionView.contentOffset = CGPoint(x: CGFloat(currentCellIndexPath.item) * size.width, y: collectionView.contentOffset.y)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.collectionView.scrollToItem(at: currentCellIndexPath, at: .left, animated: true)
        })
    }
    
    // MARK: - Helper Methods
    
    private func setup() {
        
        // Enable swipe back navigation pop
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            collectionView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
        
        // Setup Gestures
        collectionView.addGestureRecognizer(tapGesture)
        
        // Fetch data
        firstly {
            viewModel.fetch()
        }.done {
            if (self.shouldPreload) {
                self.viewModel.startPreloading()
            }
            self.reloadData()
        }
    }
    
    private func addViews() {
        view.addSubview(collectionView) {
            $0.edges.pinToSuperview()
        }
    }
    
    private func addChildViewController() {
        scrobblerViewController.didMove(toParent: self)
        addChild(scrobblerViewController)
        view.addSubview(scrobblerViewController.view)
    }
    
    private func reloadData() {
        collectionView.reloadData()
        scrobblerViewController.reloadData()
    }
    
    private func layoutScrobblerView() {
        let frame = scrobblerViewController.view.frame
        let y = scrobblerViewController.view.isHidden ? view.frame.height : view.frame.height - frame.height
        scrobblerViewController.view.frame = CGRect(x: frame.origin.x, y: y, width: view.frame.width, height: 200)
    }
    
    private func toggleScrobblerHidden() -> Promise<Void> {
        guard let navIsHidden = navigationController?.navigationBar.isHidden else { return Promise() }
        navigationController?.setNavigationBarHidden(!navIsHidden, animated: true)
        
        layoutScrobblerView()
        let wasHidden = scrobblerViewController.view.isHidden
        let frame = scrobblerViewController.view.frame
        let endY = wasHidden ? view.frame.height - frame.height : view.frame.height
        
        scrobblerViewController.view.isHidden = false
        return firstly {
            UIView.animate(.promise, duration: TimeInterval(UINavigationController.hideShowBarDuration), animations: {
                self.scrobblerViewController.view.frame = CGRect(x: frame.origin.x, y: endY, width: frame.width, height: frame.height)
            })
            }.done { _ in
                self.scrobblerViewController.view.isHidden = !wasHidden
        }
    }
    
    // MARK: - Methods
    
    func index() -> Int {
        return viewModel.index
    }
}

extension ReaderChapterViewController: UICollectionViewDelegate {
    
}

extension ReaderChapterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let readerPageCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReaderPageCell
        readerPageCell.imageView.image = nil
        guard let imageUrl = viewModel.pageImageUrl(atIndex: indexPath.item) else {
            return readerPageCell
        }
        
        readerPageCell.activityView.startAnimating()
        
        Nuke.loadImage(
            with: imageUrl,
            options: ImageLoadingOptions(
                transition: .fadeIn(duration: 0.33)
            ),
            into: readerPageCell.imageView,
            completion: { (response, error) in
                readerPageCell.activityView.stopAnimating()
            }
        )
        
        return readerPageCell
    }
}

extension ReaderChapterViewController: UIGestureRecognizerDelegate {
    private func toggleNavigationBar() {
        guard let navIsHidden = navigationController?.navigationBar.isHidden else { return }
        navigationController?.setNavigationBarHidden(!navIsHidden, animated: true)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        print("Tap")
        print(view.frame)
        // Disable gesture
        tapGesture.isEnabled = false
        firstly {
            toggleScrobblerHidden()
        }.done {
            // Re-enable gesture
            self.tapGesture.isEnabled = true
            print(self.view.frame)
        }
        print(view.frame)
    }
}
