//
//  ReaderScrobblerCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 21/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import NVActivityIndicatorView

class ReaderScrobblerCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.magnificationFilter = .trilinear
        imageView.layer.minificationFilter = .trilinear
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let activityView = NVActivityIndicatorView(frame: CGRect.zero,
                                               type: .circleStrokeSpin,
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
        addSubview(imageView) {
            $0.edges.pinToSuperview()
        }
        
        addSubview(activityView) {
            $0.height.match(al.height * 0.1)
            $0.width.match(al.width * 0.1)
            $0.center.align(with: al.center)
        }
    }
}
