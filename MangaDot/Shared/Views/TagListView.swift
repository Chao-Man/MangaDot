//
//  TagListView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 26/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class TagListView: UIView {
    private var tagViews: [TagView] = []
    private var currentPoint = CGPoint(x: 0, y: 0)
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private let horizontalSpacing: CGFloat = 4
    private let verticalSpacing: CGFloat = 4
    private lazy var heightConstraint = {
        al.height.set(height)
    }()

    // MARK: - Methods

    func addTags(withTextList text: [String], color: UIColor = MangaDot.Color.pink) {
        text.forEach { addTag(withText: $0, color: color) }
        updateLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Only relayout if width has changed, avoids loop.
        if width != frame.width {
            updateLayout()
        }
    }

    // MARK: - Helper Methods
    
    private func updateLayout() {
        relayoutTags()
        heightConstraint.constant = height
        width = frame.width
    }

    private func addTag(withText text: String, color: UIColor = MangaDot.Color.pink) {
        let tag = TagView(text, color: color)
        tagViews.append(tag)
    }

    private func removeTagsFromView() {
        tagViews.forEach { $0.removeFromSuperview() }
    }

    private func relayoutTags() {
        removeTagsFromView()
        currentPoint = CGPoint(x: 0, y: 0)
        tagViews.forEach {
            var labelSize = $0.size()
            if labelSize.width > frame.width { // Label is longer than container
                // Truncate tail of label
                let text = $0.label.text!
                let charWidth = (labelSize.width / CGFloat(text.count))
                let maxFittableChars = Int(floor(frame.width / charWidth) - 3)
                $0.label.text = text.prefix(maxFittableChars) + "..."
                labelSize = $0.size()
            }
            if height == 0 { height += (labelSize.height + verticalSpacing) }
            if (currentPoint.x + labelSize.width) > bounds.width {
                let rowHeight = (labelSize.height + verticalSpacing)
                currentPoint.x = 0
                currentPoint.y += rowHeight
                height += rowHeight
            }
            $0.frame.origin = currentPoint
            currentPoint.x += (labelSize.width + verticalSpacing)
            addSubview($0)
        }
    }
}
