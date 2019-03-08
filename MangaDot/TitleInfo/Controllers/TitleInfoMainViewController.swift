//
//  TitleInfoTableViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import SwiftIcons

class TitleInfoMainViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    private let viewModel: TitleInfoViewModel
    private let reuseIdentifier = "TitleInfoCell"
    private let controlViewHeight: CGFloat = 80
    
    // MARK: - Computed Instance Properties
    
    private let tablePaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = MangaDot.Color.white
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = PassThroughTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(TitleInfoChapterCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 70
        tableView.separatorInset = UIEdgeInsets(top: 0, left: (tableView.rowHeight * 2) + 10, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: controlViewHeight, left: 0, bottom: 0, right: 0)
        tableView.tableHeaderView = tablePaddingView
        return tableView
    }()
    
    private lazy var controlsContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = UIStackView.Alignment.center
        view.distribution = UIStackView.Distribution.fillEqually
        view.spacing = 15
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private lazy var separator: SeparatorView = {
        let view = SeparatorView(axis: .horizontal, inset: 0, width: 0.5, color: MangaDot.Color.lightGray)
        return view
    }()

    private lazy var backButton: RoundedButton = {
        let font = MangaDot.Font.regularNormal
        let iconSize = font.pointSize
        let primaryColor = MangaDot.Color.pink
        let icon = FontType.ionicons(.androidArrowBack)
        let secondaryColor = MangaDot.Color.veryWhiteGray
        let button = RoundedButton(
            font: font,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            postfixText: "TitleInfo.button.back".localized(),
            icon: icon,
            iconSize: iconSize)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: RoundedButton = {
        let font = MangaDot.Font.regularNormal
        let iconSize = font.pointSize
        let primaryColor = MangaDot.Color.pink
        let icon = FontType.ionicons(.plus)
        let secondaryColor = MangaDot.Color.veryWhiteGray
        let button = RoundedButton(
            font: font,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            postfixText: "TitleInfo.button.add".localized(),
            icon: icon,
            iconSize: iconSize)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(handleOrder), for: .touchUpInside)
        return button
    }()
    
    private lazy var resumeButton: RoundedButton = {
        let font = MangaDot.Font.regularNormal
        let iconSize = font.pointSize
        let primaryColor = MangaDot.Color.pink
        let icon = FontType.ionicons(.play)
        let secondaryColor = MangaDot.Color.veryWhiteGray
        let button = RoundedButton(
            font: font,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            postfixText: "TitleInfo.button.resume".localized(),
            icon: icon,
            iconSize: iconSize)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonTouchAnimation(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(handleLanguage), for: .touchUpInside)
        return button
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
        setup()
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layer.shadowColor = MangaDot.Color.gray.cgColor
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.shadowRadius = 5
        tableView.layer.shouldRasterize = true
        tableView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: - Methods
    
    func loadContent() {
        tableView.reloadData()
        fadeInViews()
    }
    
    @objc func handleButtonTouchAnimation(_ sender: RoundedButton) {
        UIView.animate(withDuration: 0.1) {
            sender.invertColors()
        }
    }
    
    @objc func handleSort() {
        
    }
    
    @objc func handleOrder() {
        
    }
    
    @objc func handleLanguage() {
        
    }
    
    @objc func handleClose() {
        guard let parentViewController = parent as? TitleInfoContainerViewController else {
            return
        }
        parentViewController.handleClose()
    }
    
    // MARK: - Helper Methods
    
    private func setup() {
        view.backgroundColor = MangaDot.Color.white
        addViews()
    }
    
    private func addViews() {
        view.addSubview(controlsContainer) {
            $0.top.pinToSuperviewMargin()
            $0.edges(.left, .right).pinToSuperview()
            $0.height.set(controlViewHeight)
        }
        
        view.addSubview(tableView) {
            $0.edges.pinToSuperview()
        }
        
        controlsContainer.addArrangedSubview(backButton)
        controlsContainer.addArrangedSubview(addButton)
        controlsContainer.addArrangedSubview(resumeButton)
    }
    
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

extension TitleInfoMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sortedChapters = viewModel.sortedChapters else { return }
        let readerViewModel = ReaderViewModel(source: viewModel.source, basicChaptersOrdered: sortedChapters, chapterOrder: .descending)
        let readerViewController = ReaderViewController(selectedIndex: indexPath.item, viewModel: readerViewModel)
        
        navigationController?.pushViewController(readerViewController, animated: true)
    }
}
