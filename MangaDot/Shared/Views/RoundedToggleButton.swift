//
//  RoundedToggleButton.swift
//  MangaDot
//
//  Created by Jian Chao Man on 13/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import SwiftIcons

class RoundedToggleButton: InvertableButton {
    private var textFont: UIFont
    private var primaryColor: UIColor
    private var secondaryColor: UIColor
    private var prefixText: String
    private var postfixText: String
    private var untoggledIcon: FontType
    private var toggledIcon: FontType
    private var icon: FontType {
        get {
            return isSelected ? toggledIcon : untoggledIcon
        }
    }
    private var iconSize: CGFloat
    
    init(font: UIFont = MangaDot.Font.regularNormal,
         primaryColor: UIColor = MangaDot.Color.pink,
         secondaryColor: UIColor = MangaDot.Color.veryWhiteGray,
         prefixText: String = "",
         postfixText: String = "",
         untoggledIcon: FontType = FontType.icofont(.aids),
         toggledIcon: FontType = FontType.icofont(.aids),
         iconSize: CGFloat) {
        
        self.textFont = font
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.prefixText = "\(prefixText)  "
        self.postfixText = "  \(postfixText)"
        self.untoggledIcon = untoggledIcon
        self.toggledIcon = toggledIcon
        self.iconSize = iconSize
        
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
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
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    override func invertColors() {
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
