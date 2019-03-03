//
//  RoundedButton.swift
//  MangaDot
//
//  Created by Jian Chao Man on 10/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import SwiftIcons

class RoundedButton: UIButton {
    private var textFont: UIFont
    private var primaryColor: UIColor
    private var secondaryColor: UIColor
    private var prefixText: String
    private var postfixText: String
    private var icon: FontType
    
    init(font: UIFont = MangaDot.Font.regularNormal,
         primaryColor: UIColor = MangaDot.Color.pink,
         secondaryColor: UIColor = MangaDot.Color.veryWhiteGray,
         prefixText: String = "", postfixText: String = "",
         icon: FontType = FontType.icofont(.aids)) {
        
        self.textFont = font
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.prefixText = prefixText
        self.postfixText = postfixText
        self.icon = icon
        
        super.init(frame: CGRect.zero)
        
        setIcon(
            prefixText: prefixText,
            prefixTextFont: font,
            prefixTextColor: primaryColor,
            icon: icon,
            iconColor: primaryColor,
            postfixText: " " + postfixText,
            postfixTextFont: font,
            postfixTextColor: primaryColor,
            backgroundColor: secondaryColor,
            forState: .normal,
            iconSize: font.pointSize
        )
        
        titleLabel?.lineBreakMode = .byClipping
        titleLabel?.numberOfLines = 1
        layer.cornerRadius = MangaDot.CornerRadius.buttons
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        layer.shadowColor = MangaDot.Color.pink.cgColor
////        layer.shadowOpacity = 0.1
////        layer.shadowRadius = 4
////        layer.shadowOffset = CGSize(width: 0, height: 1)
////        layer.shouldRasterize = true
////        layer.rasterizationScale = UIScreen.main.scale
//    }
    
    func invertColors() {
        swapColors()
        setIcon(
            prefixText: prefixText,
            prefixTextFont: textFont,
            prefixTextColor: primaryColor,
            icon: icon,
            iconColor: primaryColor,
            postfixText: " " + postfixText,
            postfixTextFont: textFont,
            postfixTextColor: primaryColor,
            backgroundColor: secondaryColor,
            forState: .normal,
            iconSize: textFont.pointSize
        )
    }
    
    private func swapColors() {
        let temp = primaryColor
        primaryColor = secondaryColor
        secondaryColor = temp
    }
}
