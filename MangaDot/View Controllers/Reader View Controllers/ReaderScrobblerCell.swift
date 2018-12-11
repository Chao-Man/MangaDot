//
//  ReaderScrobblerCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 21/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class ReaderScrobblerCell: UICollectionViewCell {
    var used = false
    var pageThumbnailView = PageThumbnailView()

    private func setup(imageUrl: URL) {
        used = true

        // Add Subviews
        contentView.addSubview(pageThumbnailView)

        // Set Image Container Constraints
        pageThumbnailView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }

        recycle(imageUrl: imageUrl)
    }

    func recycle(imageUrl: URL) {
        if used == true {
            loadImage(imageUrl: imageUrl)
        } else {
            setup(imageUrl: imageUrl)
        }
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.layer.shouldRasterize = true
    }

    private func loadImage(imageUrl: URL) {
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: bounds.width * 2, height: bounds.height * 2), mode: .aspectFit)
        // Clear existing image
        pageThumbnailView.imageView.image = nil
        pageThumbnailView.kf.setImage(with: imageUrl, options: [.transition(.fade(0.2)), .processor(processor)])
    }
}
