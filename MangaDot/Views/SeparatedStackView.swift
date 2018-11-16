//
//  SeparatedStackView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import SnapKit
import UIKit

class SeparatedStackView: UIStackView {
    override func addArrangedSubview(_ view: UIView) {
        if arrangedSubviews.count < 1 {
            super.addArrangedSubview(view)
            return
        }

        let separator = SeparatorView(axis: .horizontal)
        super.addArrangedSubview(separator)

        if axis == .vertical {
            separator.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalToSuperview()
            }
        } else {
            separator.snp.makeConstraints { make in
                make.width.equalTo(40)
                make.height.equalToSuperview()
            }
        }
        super.addArrangedSubview(view)
    }
}
