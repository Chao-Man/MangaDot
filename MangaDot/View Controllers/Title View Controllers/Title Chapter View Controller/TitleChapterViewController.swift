//
//  TitleChapterViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class TitleChapterViewController: UITableViewController {
    // MARK: - Propeties

    var palette: UIImageColors? {
        didSet {
            applyPalette(palette: palette)
        }
    }

    var viewModel: TitleChapterViewModel? {
        didSet {
            if viewModel != nil {
                tableView.reloadData()
            }
        }
    }

    // MARK: - View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper Methods

    private func setupView() {
        view.backgroundColor = .clear
        tableView.rowHeight = 70
        tableView.register(ChapterCell.self, forCellReuseIdentifier: "ChapterCell")
    }

    private func applyPalette(palette: UIImageColors?) {
        UIView.transition(with: view, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            if let palette = palette {
                self.tableView.separatorColor = palette.primary.withAlphaComponent(0.2)
                self.tableView.reloadData()
            } else {
                self.tableView.separatorColor = nil
            }
        }, completion: nil)
    }
}

extension TitleChapterViewController {
    // MARK: - Delegate Methods

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfChapters()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapterCell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as! ChapterCell

        guard let viewModel = viewModel else {
            return chapterCell
        }
        let chapterData = viewModel.chapters[indexPath.row]
        chapterCell.recycle(chapterData: chapterData, palette: palette)
        return chapterCell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        let selectedChapterId = viewModel.chapter(index: indexPath.item).id
        let readerViewController = ReaderViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        let readerViewModel = ReaderViewModel(id: selectedChapterId)
        readerViewController.viewModel = readerViewModel
        navigationController?.pushViewController(readerViewController, animated: true)
    }
}
