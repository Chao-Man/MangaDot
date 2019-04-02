//
//  InvertableButton.swift
//  MangaDot
//
//  Created by Jian Chao Man on 13/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

class InvertableButton: UIButton {

    func setup() {
        layer.cornerRadius = MangaDot.CornerRadius.buttons
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func invertColors() {
    }
}

