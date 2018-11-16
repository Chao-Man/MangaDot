//
//  UIImageView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

extension UIImageView: Placeholder {
    public func add(to imageView: ImageView) {
        imageView.addSubview(self)
        snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageView)
            make.bottom.equalTo(imageView)
            make.left.equalTo(imageView)
            make.right.equalTo(imageView)
        }
        // also set constraints
    }

    public func remove(from _: ImageView) {
        removeFromSuperview()
    }
}
