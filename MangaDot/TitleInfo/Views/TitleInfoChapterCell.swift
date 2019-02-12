//
//  TitleInfoChapterCelll.swift
//  MangaDot
//
//  Created by Jian Chao Man on 8/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class TitleInfoChapterCell: UITableViewCell {
    // MARK: - Computed Instance Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldSmall
        label.textColor = MangaDot.Color.pink
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.lightSmaller
        label.textColor = MangaDot.Color.gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.lightTiny
        label.textColor = MangaDot.Color.pink
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()
    
    lazy var chapterFlipBoard: FlipBoardView = {
        let view = FlipBoardView(frame: CGRect.zero)
        view.backgroundColor = MangaDot.Color.white
        view.labelColor = MangaDot.Color.pink
        return view
    }()
    
    lazy var volumeFlipBoard: FlipBoardView = {
        let view = FlipBoardView(frame: CGRect.zero)
        view.backgroundColor = MangaDot.Color.white
        view.labelColor = MangaDot.Color.gray
        return view
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        timeLabel.sizeToFit()
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        super.layoutSubviews()
    }
    
    // MARK: - Helper Methods
    
    private func setup() {
        layoutMargins = Inset(10)
        backgroundColor = MangaDot.Color.white
        isOpaque = true
        addViews()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func addViews() {
        addSubview(timeLabel) {
            $0.right.pinToSuperviewMargin()
            $0.bottom.pinToSuperviewMargin()
        }
        
        addSubview(chapterFlipBoard, volumeFlipBoard, titleLabel, subtitleLabel) {
            $0.left.pinToSuperview(inset: 10)
            $0.edges(.top, .bottom).pinToSuperview()
            $0.width.match(al.height)
            
            $1.edges(.top, .bottom).pinToSuperview()
            $1.left.align(with: $0.right)
            $1.width.match(al.height)
            
            $2.bottom.align(with: al.centerY - 5)
            $2.left.align(with: $1.right + 10)
            $2.right.align(with: timeLabel.al.right)
            
            $3.top.align(with: al.centerY + 5)
            $3.left.align(with: $1.right + 10)
            $3.right.align(with: timeLabel.al.right)
        }
    }
}
