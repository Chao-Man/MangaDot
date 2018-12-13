//
//  PageThumbnailView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/12/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class PageThumbnailView: UIView {
    var imageView: RoundedImageView
    var kf: KingfisherWrapper<RoundedImageView>

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        imageView = RoundedImageView()
        kf = imageView.kf
        super.init(frame: frame)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(imageView)

        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
        imageView.layer.magnificationFilter = .trilinear
        imageView.layer.minificationFilter = .trilinear

        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
