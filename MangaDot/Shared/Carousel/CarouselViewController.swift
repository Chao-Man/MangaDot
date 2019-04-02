//
//  CarouselViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Nuke
import PromiseKit
import UIKit
import Yalta

class CarouselViewController: UIViewController {
    // MARK: - Instance Properties

    private let viewModel: CarouselViewModel
    private let source: SourceProtocol
    private let itemSize = CGSize(width: 145, height: 265)
    private let reuseIdentifier = "CarouselCell"
    private let scrollDirection: UICollectionView.ScrollDirection
    private var selectedCell: CarouselCell?

    // MARK: - Computed Instance Properties

    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 45)
        layout.scrollDirection = .horizontal
        layout.itemSize = itemSize
        return layout
    }()

    private lazy var headerView: UILabel = {
        let headerView = UILabel()
        headerView.font = MangaDot.Font.boldLarge
        headerView.text = viewModel.sectionName().localized()
        return headerView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - View Life Cycle

    init(data: SectionProtocol, source: SourceProtocol, scrollDirection: UICollectionView.ScrollDirection = .horizontal) {
        self.viewModel = CarouselViewModel(data)
        self.source = source
        self.scrollDirection = scrollDirection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Helper Methods

    private func setupViews() {
        // Add Subviews
        view.addSubview(headerView) {
            $0.right.pinToSuperview()
            $0.top.pinToSuperview(inset: 15)
            $0.left.pinToSuperview(inset: 45)
        }
        view.addSubview(collectionView) {
            $0.top.align(with: headerView.al.bottom + 5)
            $0.edges(.left, .right).pinToSuperview()
            $0.bottom.pinToSuperview(inset: 5, relation: .equal)
            $0.height.set(itemSize.height)
        }
        view.backgroundColor = .white
        view.isOpaque = true
    }
    
    private func setNavigationDelegateToSelf() {
        navigationController?.delegate = self
    }
}

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.numberOfManga()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CarouselCell
        cell.titleLabel.text = viewModel.mangaTitle(withIndex: indexPath.item)
        loadCoverImage(imageView: cell.coverView.imageView, index: indexPath.item)
        return cell
    }

    // MARK: - Private Helper Methods

    private func loadCoverImage(imageView: UIImageView, index: Int) {
        imageView.image = UIImage()
        firstly {
            viewModel.fetchSmallCover(withIndex: index, imageView: imageView)
        }.done { imageResponse in
            self.viewModel.fetchLargeCover(withIndex: index, imageView: imageView, placeholderImage: imageResponse.image)
        }.catch { error in
            print(error)
        }
    }

    private func coverImageSize() -> CGSize {
        return CGSize(width: itemSize.width * UIScreen.main.scale,
                      height: itemSize.height * UIScreen.main.scale)
    }
}

extension CarouselViewController: UICollectionViewDelegate {
//    func collectionView(_: UICollectionView, didEndDisplaying _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        viewModel.cancelDownloadTask(atIndex: indexPath.item)
//    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.mangaId(withIndex: indexPath.item) else { return }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CarouselCell else { return }
        
        setNavigationDelegateToSelf()
        
        // Set local property selected cell
        self.selectedCell = selectedCell
        let placeholder = selectedCell.coverView.imageView.image
        
        // Load view controller
        let titleInfoViewController = TitleInfoContainerViewController(id: id, source: source, placeholder: placeholder)
        navigationController?.pushViewController(titleInfoViewController, animated: true)
    }
}

extension CarouselViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // TODO: Remove
//        navigationController.delegate = nil
        
        guard ((fromVC is FeedViewController && toVC is TitleInfoContainerViewController) ||
            (fromVC is TitleInfoContainerViewController && toVC is FeedViewController)) else {
                return nil
        }
        
        switch operation {
            case .push:
                guard let cell = self.selectedCell else { return nil }
                return TitlePresentAnimationController(fromCoverView: cell.coverView)

            case .pop:
                guard let cell = self.selectedCell else { return nil }
                guard let fromTitleVC = fromVC as? TitleInfoContainerViewController else { return nil }
                return TitleDismissAnimationController(toCoverView: cell.coverView, interactionController: fromTitleVC.swipeInteractionController)

            default:
                return nil
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animationController as? TitleDismissAnimationController else { return nil }
        guard let interactionController = animator.interactionController else { return nil }
        guard interactionController.interactionInProgress else { return nil }
        return interactionController
    }
}
