//
//  TitleChapterViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class TitleChapterViewController: UITableViewController {
    // MARK: - Types

    private enum AlertType {
        case noChapterIdData
    }

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

    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String

        switch alertType {
        case .noChapterIdData:
            title = "Unable to load chapter"
            message = "The application is unable to fetch chapter data. Please make sure your device is connected over Wi-Fi or cellular."
        }

        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Present Alert Controller
        present(alertController, animated: true)
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
        do {
            let selectedChapterId = viewModel.chapter(index: indexPath.item).id
            let chapterIds = viewModel.chapterIds()
            let readerViewController = ReaderPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            let readerViewModel = try ReaderViewModel(selectedChapterId: selectedChapterId, chapterIds: chapterIds)
            readerViewController.viewModel = readerViewModel
            readerViewController.title = "Chapter \(viewModel.chapters[indexPath.row].chapter)"
            navigationController?.pushViewController(readerViewController, animated: true)
        } catch {
            presentAlert(of: .noChapterIdData)
        }
    }
}
