//
//  RoundedTranslucentButton.swift
//  MangaDot
//
//  Created by Jian Chao Man on 5/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class RoundedTranslucentButton: UIButton {
    lazy var backgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        insertSubview(backgroundView, at: 0) {
            $0.edges.pinToSuperview()
        }
        clipsToBounds = true
        layer.cornerRadius = MangaDot.CornerRadius.buttons
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        titleLabel?.sizeToFit()
//        self.layoutSubviews()
//    }
}
