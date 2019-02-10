//
//  SeparatedStackView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class SeparatedStackView: UIStackView {
    private let inset: CGFloat
    
    init(inset: CGFloat = 0) {
        self.inset = inset
        super.init(frame: CGRect.zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addArrangedSubview(_ view: UIView) {
        // Separator can't be added before first item
        if arrangedSubviews.count < 1 {
            super.addArrangedSubview(view)
            return
        }

        let separator = axis == .vertical ? SeparatorView(axis: .horizontal, inset: inset) : SeparatorView(axis: .vertical, inset: inset)
        // Add separator before adding new stack item
        super.addArrangedSubview(separator)

        // Setup constraints based on axis alignment
        if axis == .vertical {
            Constraints(for: separator) { separator in
                separator.height.set(2)
                separator.width.match(self.al.width)
            }
        } else {
            Constraints(for: separator) { separator in
                separator.width.set(2)
                separator.height.match(self.al.height)
            }
        }
        super.addArrangedSubview(view)
    }
}
