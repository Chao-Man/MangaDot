//
//  CarouselCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class CarouselCell: UICollectionViewCell {
    var used = false
    var id: Int?
    var coverView = CoverView()
    var titleView = UILabel()
    var fetcher: ImagePrefetcher = ImagePrefetcher(urls: [])

    private func setup(titleData: TitleData) {
        used = true
        id = titleData.id

        // Add Subviews
        addSubview(coverView)
        addSubview(titleView)

        // Configure Title View
        titleView.font = UIFont.MangaDot.regularSmaller
        titleView.textColor = UIColor.darkGray
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 2
        titleView.text = titleData.title

        // Set Image Container Constraints
        coverView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self.snp.width).multipliedBy(1.42)
        }

        // Set Title View Constraints
        titleView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(coverView.snp.bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        recycle(titleData: titleData)
    }

    func recycle(titleData: TitleData) {
        if used == true {
            id = titleData.id
            titleView.text = titleData.title
            loadImage(coverUrl: titleData.coverUrl, largeCoverUrl: titleData.largeCoverUrl)
        } else {
            setup(titleData: titleData)
        }
        // Resize to fit
        titleView.sizeToFit()
    }

    private func loadImage(coverUrl: URL, largeCoverUrl: URL?) {
        DispatchQueue.main.async {
            let isCoverCached = ImageCache.default.imageCachedType(forKey: coverUrl.absoluteString).cached
            if let largeCoverUrl = largeCoverUrl {
                let isLargeCoverCached = ImageCache.default.imageCachedType(forKey: largeCoverUrl.absoluteString).cached

                if !isLargeCoverCached {
                    // Large Cover is not cached, loading small cover, and downloading large cover
                    self.coverView.kf.setImage(with: coverUrl, options: [.transition(.fade(0.2))])
                    self.fetcher = ImagePrefetcher(urls: [largeCoverUrl]) { _, _, completedResources in
                        if completedResources.count > 0 {
                            // Load large cover
                            self.loadImage(coverUrl: coverUrl, largeCoverUrl: largeCoverUrl)
                        }
                    }
                    self.fetcher.start()
                } else if isCoverCached {
                    // Large Cover is cached, loading large cover
                    self.coverView.kf.setImage(with: largeCoverUrl, options: [.onlyFromCache, .transition(.fade(0.2))])
                }
            } else {
                // Large Cover does not exist, loading small cover
                self.coverView.kf.setImage(with: coverUrl, options: [.transition(.fade(0.2))])
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
