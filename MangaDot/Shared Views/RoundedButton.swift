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
    private var iconSize: CGFloat
    
    init(font: UIFont = MangaDot.Font.regularNormal,
         primaryColor: UIColor = MangaDot.Color.pink,
         secondaryColor: UIColor = MangaDot.Color.veryWhiteGray,
         prefixText: String = "",
         postfixText: String = "",
         icon: FontType = FontType.icofont(.aids),
         iconSize: CGFloat) {
        
        self.textFont = font
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.prefixText = "\(prefixText)  "
        self.postfixText = "  \(postfixText)"
        self.icon = icon
        self.iconSize = iconSize
        
        super.init(frame: CGRect.zero)
        
        setup()
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
    
    func setup() {
        setIcon(
            prefixText: prefixText,
            prefixTextFont: textFont,
            prefixTextColor: primaryColor,
            icon: icon,
            iconColor: primaryColor,
            postfixText: postfixText,
            postfixTextFont: textFont,
            postfixTextColor: primaryColor,
            backgroundColor: secondaryColor,
            forState: .normal,
            iconSize: iconSize
        )
        
        titleLabel?.lineBreakMode = .byClipping
        titleLabel?.numberOfLines = 1
        layer.cornerRadius = MangaDot.CornerRadius.buttons
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func invertColors() {
        swapColors()
        setIcon(
            prefixText: prefixText,
            prefixTextFont: textFont,
            prefixTextColor: primaryColor,
            icon: icon,
            iconColor: primaryColor,
            postfixText: postfixText,
            postfixTextFont: textFont,
            postfixTextColor: primaryColor,
            backgroundColor: secondaryColor,
            forState: .normal,
            iconSize: iconSize
        )
    }
    
    private func swapColors() {
        let temp = primaryColor
        primaryColor = secondaryColor
        secondaryColor = temp
    }
}
