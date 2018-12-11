//
//  RoundedImageView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 6/12/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    var cornerRadius: CGFloat = 4
    var options: ShadowOptions = MangaDot.Shadow.dropShadow
    let shadowLayer = CALayer()

    override var image: UIImage? {
        didSet {
            drawMaskAndShadow(image: image)
            super.image = image
        }
    }

    private func drawMaskAndShadow(image: UIImage?) {
        guard let image = image else { return }

        layer.applyMask(with: imageAspectFitMaskPath(image: image))
        shadowLayer.applyShadow(options: options, path: imageAspectFitShadowPath(image: image))

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func imageAspectFitRect(image: UIImage) -> CGRect {
        let boundsScale = bounds.size.width / bounds.size.height
        let imageScale = image.size.width / image.size.height

        var drawingRect: CGRect = bounds

        if boundsScale > imageScale {
            drawingRect.size.width = drawingRect.size.height * imageScale
            drawingRect.origin.x = (bounds.size.width - drawingRect.size.width) / 2
        } else {
            drawingRect.size.height = drawingRect.size.width / imageScale
            drawingRect.origin.y = (bounds.size.height - drawingRect.size.height) / 2
        }
        return drawingRect
    }

    private func imageAspectFitMaskPath(image: UIImage) -> CGPath {
        let drawingRect = imageAspectFitRect(image: image)
        return UIBezierPath(roundedRect: drawingRect, cornerRadius: cornerRadius).cgPath
    }

    private func imageAspectFitShadowPath(image: UIImage) -> CGPath {
        let drawingRect = increaseRect(rect: imageAspectFitRect(image: image), byPercentage: 0.1)
        return UIBezierPath(roundedRect: drawingRect, cornerRadius: cornerRadius).cgPath
    }

    private func increaseRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = rect.width
        let startHeight = rect.height
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
        return rect.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
    }
}
