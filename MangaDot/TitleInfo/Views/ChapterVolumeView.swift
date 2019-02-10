//
//  ChapterVolumeView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 8/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class ChapterVolumeView: UIView {
    // MARK: - Instance Properties
    private let cornerRadius: CGFloat
    
    // MARK: - Computed Instance Properties
    
    lazy var chapterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldSmaller
        label.textColor = MangaDot.Color.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var volumeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldSmaller
        label.textColor = MangaDot.Color.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var chapterNumberLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.regularLarge
        label.textColor = MangaDot.Color.white
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var volumeNumberLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.regularLarge
        label.textColor = MangaDot.Color.white
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var chapterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = MangaDot.Color.pink
        return view
    }()
    
    lazy var volumeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = MangaDot.Color.lightGray
        return view
    }()
    
    // MARK: - Life Cycle
    
    init(frame: CGRect, cornerRadius: CGFloat = 4) {
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func setupView() {
        addViews()
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    private func addViews() {
        addSubview(chapterContainerView, volumeContainerView) {
            $0.edges(.left, .top, .bottom).pinToSuperview()
            $0.left.align(with: $0.right, relation: .equal)
            $0.width.match(al.width * 0.5)
            $1.edges(.right, .top, .bottom).pinToSuperview()
            $1.width.match(al.width * 0.5)
        }
    }
}
