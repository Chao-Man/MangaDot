//
//  CarouselCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CarouselCell: UICollectionViewCell {
    var used = false
    var id: Int?
    var imageView = UIImageView()
    var imageContainer = UIView()
    var titleView = UILabel()
    
    let cornerRadius: CGFloat = 10.0
    
    private func setup(titleData: TitleData) {
        used = true
        id = titleData.id
        
        // Add Subviews
        imageContainer.addSubview(imageView)
        self.addSubview(imageContainer)
        self.addSubview(titleView)
        
        // Configure Image Container
//        imageContainer.layer.cornerRadius = 10.0
//        imageContainer.layer.borderColor = UIColor.lightGray.cgColor
//        imageContainer.layer.borderWidth = 0.4
//        imageContainer.layer.shouldRasterize = true
//        imageContainer.layer.rasterizationScale = UIScreen.main.scale
        
        // Configure Image View
        imageView.backgroundColor = .white
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: titleData.coverUrl)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.magnificationFilter = .trilinear
        imageView.layer.minificationFilter = .trilinear
        imageView.layer.cornerRadius = cornerRadius
        
        // Configure Title View
        titleView.font = UIFont.MangaDot.regularSmaller
        titleView.textColor = UIColor.darkGray
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 2
        titleView.text = titleData.title
        
        // Set Image Container Constraints
        imageContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self.snp.width).multipliedBy(1.42)
        }
        
        // Set Image View Constraints
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageContainer)
            make.left.equalTo(imageContainer)
            make.right.equalTo(imageContainer)
            make.bottom.equalTo(imageContainer)
        }
        
        // Set Title View Constraints
        titleView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageContainer.snp.bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
    }
    
    func recycle(titleData: TitleData) {
        if used == true {
            id = titleData.id
            titleView.text = titleData.title
            imageView.kf.setImage(with: titleData.coverUrl)
        }
        else {
            setup(titleData: titleData)
        }
        // Resize to fit
        titleView.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.layer.cornerRadius = cornerRadius
        imageContainer.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 1, blur: 5, spread: 0)
        imageContainer.layer.shouldRasterize = true
        imageContainer.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: - Helper Methods
    
    // Uses high resolution cover images for title thumbnails
    // Ended up using way too much memory, older ipads are completely memory limited
    // Uses something like 290~ mb of ram.
    
    /**
     private func setImageView(coverUrl: URL, largeCoverUrl: URL?) {
     // Load high resolution image if exists
     if let largeCoverUrl = largeCoverUrl {
     // Load low resolution thumbnail as placeholder
     let thumbnail = UIImageView()
     thumbnail.kf.setImage(with: coverUrl)
     thumbnail.contentMode = .scaleAspectFill
     imageView.kf.setImage(with: largeCoverUrl, placeholder: thumbnail as Placeholder, options: [], progressBlock: nil, completionHandler: nil)
     }
     // Otherwise use low resolution thumbnail
     else {
     imageView.kf.setImage(with: coverUrl)
     }
     }
     **/
}
