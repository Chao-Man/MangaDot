//
//  PassThroughTableView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 1/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit


class PassThroughTableView: UITableView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
