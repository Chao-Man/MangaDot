//
//  CoverView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class CoverView: DropShadowView {
    private var _cornerRadius: CGFloat = 4
    var imageView: UIImageView
    let kf: KingfisherWrapper<UIImageView>

    var cornerRadius: CGFloat {
        set {
            _cornerRadius = newValue
            setup()
        }
        get { return _cornerRadius }
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        imageView = UIImageView()
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
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.magnificationFilter = .trilinear
        imageView.layer.minificationFilter = .trilinear
        imageView.layer.cornerRadius = cornerRadius

        layer.magnificationFilter = .nearest
        layer.minificationFilter = .nearest

        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
