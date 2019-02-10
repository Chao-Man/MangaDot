//
//  TitleInfoTableViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

class TitleInfoMainViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    private let viewModel: TitleInfoViewModel
    private let reuseIdentifier = "TitleInfoCell"
    
    // MARK: - Computed Instance Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(TitleInfoChapterCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 65
        tableView.separatorInset = UIEdgeInsets(top: 0, left: (tableView.rowHeight * 2) + 10, bottom: 0, right: 0)
        return tableView
    }()
    
    private lazy var controlStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()

    init(viewModel: TitleInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setViewsTransparent()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        view.addSubview(tableView) {
            $0.edges.pinToSuperview()
        }
        view.backgroundColor = MangaDot.Color.white
    }
    
    // MARK: - Methods
    
    func loadContent() {
        tableView.reloadData()
        fadeInViews()
    }
    
    // MARK: - Helper Methods
    
    private func setViewsTransparent() {
        tableView.alpha = 0.0
    }
    
    private func fadeInViews() {
        UIView.animate(withDuration: 0.8) {
            self.tableView.alpha = 1.0
        }
    }
}

extension TitleInfoMainViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.numberOfChapters()
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chapterData = viewModel.chapter(index: indexPath.item) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TitleInfoChapterCell else { return UITableViewCell() }
        let chapterViewModel = TitleInfoChapterViewModel(chapterData: chapterData)
        cell.titleLabel.text = chapterViewModel.title()
        cell.subtitleLabel.text = chapterViewModel.group()
        cell.timeLabel.text = chapterViewModel.lastUpdated()
        cell.chapterFlipBoard.numberLabel.text = chapterViewModel.chapterNumber()
        cell.volumeFlipBoard.numberLabel.text = chapterViewModel.volumeNumber()
        cell.chapterFlipBoard.titleLabel.text = "ChapterCell.label.chapter".localized()
        cell.volumeFlipBoard.titleLabel.text = "ChapterCell.label.volume".localized()
        return cell
    }
}

extension TitleInfoMainViewController: UITableViewDelegate {}
