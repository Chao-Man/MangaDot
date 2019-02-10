//
//  BorderLabel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 24/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class TagView: UIButton {
    // MARK: Computed Instance Properties

    lazy var label: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.regularSmaller
        label.textColor = color
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.text = ""
        return label
    }()

    private var text: String
    private var color: UIColor

    let verticalInset: CGFloat = 5
    let horizontalInset: CGFloat = 10

    // MARK: - Life Cycle

    init(_ text: String = "", color: UIColor = MangaDot.Color.pink) {
        self.text = text
        self.color = color
        super.init(frame: CGRect.zero)
        setupViews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        label.sizeToFit()
        label.frame.origin = CGPoint(x: horizontalInset, y: verticalInset)
        frame.size = CGSize(width: label.frame.size.width + label.frame.origin.x + horizontalInset,
                            height: label.frame.size.height + label.frame.origin.y + verticalInset)
        layer.cornerRadius = frame.height / 2
        super.layoutSubviews()
    }

    // MARK: - Methods

    func size() -> CGSize {
        let labelSize = label.text!.size(withAttributes: [NSAttributedString.Key.font: label.font!])
        return CGSize(width: labelSize.width + (horizontalInset * 2), height: labelSize.height + (verticalInset * 2))
    }

    // MARK: - Helper Methods

    private func setupViews() {
        addSubview(label)
        label.text = text
        backgroundColor = MangaDot.Color.whiteGray
    }
}
