//
//  UIImageView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

extension UIImageView: Placeholder {
    public func add(to imageView: ImageView) {
        imageView.addSubview(self)
        self.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageView)
            make.bottom.equalTo(imageView)
            make.left.equalTo(imageView)
            make.right.equalTo(imageView)
        }
        // also set constraints
    }
    public func remove(from imageView: ImageView) {
        self.removeFromSuperview()
    }
}
