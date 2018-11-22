//
//  ReaderPageViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 16/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class ReaderPageContentViewController: UIViewController {
    // MARK: - Properties

    let imageUrl: URL
    var imageView = UIImageView() {
        didSet {
            imageView.layer.magnificationFilter = .trilinear
            imageView.layer.minificationFilter = .trilinear
            updateImageContentMode()
        }
    }

    var scrollView = UIScrollView() {
        didSet {
            updateScrollViewScaling()
        }
    }

    init(imageUrl: URL) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
//        updateViewConstraints()
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        setupViews()
        updateViewConstraints()
        super.viewDidLoad()
    }

    override func updateViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }

        super.updateViewConstraints()
    }

    private func updateImageContentMode() {
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }

    private func updateScrollViewScaling() {
        scrollView.isUserInteractionEnabled = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.contentSize = imageView.frame.size
    }

    private func setupViews() {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl, completionHandler: {
            _, _, _, _ in
            self.updateImageContentMode()
            self.updateScrollViewScaling()
        })
        scrollView.delegate = self
        scrollView.addSubview(imageView)

        // Add views
        view.addSubview(scrollView)
        view.backgroundColor = .white
    }
}

extension ReaderPageContentViewController: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ReaderPageContentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
