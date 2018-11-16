//
//  ChapterCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 10/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import SwiftDate
import UIKit

class ChapterCell: UITableViewCell {
    private let wrapper = UIView()
    private let chapterLabel = UILabel()
    private let volumeLabel = UILabel()
    private let titleLabel = UILabel()
    private let groupLabel = UILabel()
    private let updatedLabel = UILabel()
    private let selectedBgView = UIView()
    var used = false
    var palette: UIImageColors?

    func recycle(chapterData: TitleChapterData, palette: UIImageColors?) {
        if self.palette == nil && palette != nil {
            self.palette = palette
            setup(chapterData: chapterData)
        } else {
            if used == true {
                setupValues(chapterData: chapterData)
            } else {
                setup(chapterData: chapterData)
            }
        }
    }

    private func setup(chapterData: TitleChapterData) {
        used = true
        setupValues(chapterData: chapterData)
        setupViews()
        setupColors()
        setupConstraints()
    }

    private func setupValues(chapterData: TitleChapterData) {
        if chapterData.volume != "" {
            volumeLabel.text = "ChapterCell.label.volume".localized()
            volumeLabel.text?.append(chapterData.volume)
        }

        if chapterData.chapter != "" {
            chapterLabel.text = "ChapterCell.label.chapter".localized()
            chapterLabel.text?.append(chapterData.chapter)
        }

        titleLabel.text = chapterData.title
        groupLabel.text = chapterData.groupName
        updatedLabel.text = chapterData.timestamp.toRelative()
    }

    private func setupViews() {
        backgroundColor = .clear

        volumeLabel.font = UIFont.MangaDot.regularTiny
        chapterLabel.font = UIFont.MangaDot.boldTiny
        titleLabel.font = UIFont.MangaDot.regularNormal
        updatedLabel.font = UIFont.MangaDot.lightSmall
        groupLabel.font = UIFont.MangaDot.regularSmall

        titleLabel.textAlignment = .left
        updatedLabel.textAlignment = .right

        addSubview(wrapper)
        wrapper.addSubview(volumeLabel)
        wrapper.addSubview(chapterLabel)
        wrapper.addSubview(titleLabel)
        wrapper.addSubview(groupLabel)
        wrapper.addSubview(updatedLabel)

        selectedBgView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
        selectedBackgroundView = selectedBgView
    }

    func setupColors() {
        if let palette = self.palette {
            volumeLabel.textColor = palette.detail.withAlphaComponent(0.5)
            chapterLabel.textColor = palette.detail
            titleLabel.textColor = palette.primary
            groupLabel.textColor = palette.secondary
            updatedLabel.textColor = palette.detail
            selectedBgView.backgroundColor = palette.primary.withAlphaComponent(0.2)
        } else {
            volumeLabel.textColor = .gray
            chapterLabel.textColor = .gray
            titleLabel.textColor = .black
            groupLabel.textColor = .lightGray
            updatedLabel.textColor = .lightGray
            selectedBgView.backgroundColor = .lightGray
        }
    }

    private func setupConstraints() {
        // View
        wrapper.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(20)
        }

        // Chapter Label
        chapterLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalTo(wrapper.snp.centerY)
            make.left.equalToSuperview()
            make.width.equalTo(100)
        }

        // Volume Label
        volumeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(chapterLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(chapterLabel)
            make.right.equalTo(chapterLabel)
        }

        // Title Label
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalTo(wrapper.snp.centerY)
            make.leading.equalTo(chapterLabel.snp.trailing)
            make.trailing.equalTo(updatedLabel.snp.leading).offset(-10)
        }

        // Group Label
        groupLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }

        // Updated Label
        updatedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
