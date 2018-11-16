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

class ReaderPageViewController: UIViewController {
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
        print(imageUrl)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height)
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
            (image, error, cacheType, imageUrl) in
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

extension ReaderPageViewController: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ReaderPageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
