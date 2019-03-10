//
//  LightTranslucentView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class LightTranslucentView: TranslucentView {
    let whiteOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteOverlayView) {
            $0.edges.pinToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
