//
//  BorderCoverView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 24/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class BorderCoverView: UIView {
    private var cornerRadius: CGFloat
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.magnificationFilter = .trilinear
        imageView.layer.minificationFilter = .trilinear
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = MangaDot.Color.lightGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.shouldRasterize = true
        imageView.isOpaque = true
        return imageView
    }()
    
    convenience init(cornerRadius: CGFloat = MangaDot.CornerRadius.coverView) {
        self.init(frame: CGRect.zero, cornerRadius: cornerRadius)
    }
    
    init(frame: CGRect, cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(imageView) {
            $0.edges.pinToSuperview()
        }
    }
}
