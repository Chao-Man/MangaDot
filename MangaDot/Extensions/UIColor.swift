//
//  UIColor.swift
//  MangaDot
//
//  Created by Jian Chao Man on 7/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    public var barStyle: UIBarStyle {
        var hue: CGFloat = 0
        var brightness: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return brightness > 0.5 ? UIBarStyle.default : UIBarStyle.black
    }
}
