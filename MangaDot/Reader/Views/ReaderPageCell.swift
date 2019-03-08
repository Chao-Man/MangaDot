//
//  ReaderPageCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import NVActivityIndicatorView

class ReaderPageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.magnificationFilter = .trilinear
        imageView.layer.minificationFilter = .trilinear
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    
    let activityView = NVActivityIndicatorView(frame: CGRect.zero,
                                                       type: .orbit,
                                                       color: MangaDot.Color.pink)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addViews()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func addViews() {
        addSubview(scrollView) {
            $0.edges.pinToSuperview()
        }
        
        scrollView.addSubview(imageView) {
            $0.height.match(scrollView.al.height)
            $0.width.match(scrollView.al.width)
        }
        
        scrollView.addSubview(activityView) {
            $0.height.match(scrollView.al.height * 0.1)
            $0.width.match(scrollView.al.width * 0.1)
            $0.center.align(with: scrollView.al.center)
        }
    }
}

extension ReaderPageCell: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        return imageView
    }
}
