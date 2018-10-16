//
//  ChapterViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class ChapterViewController: UITableViewController {
    
    // MARK: - Propeties
    
    var palette: UIImageColors? {
        didSet {
            self.applyPalette(palette: palette)
        }
    }
    
    var viewModel: ChapterViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    // MARK: - Helper Methods
    
    private func setupView() {
        view.backgroundColor = .clear
        tableView.register(ChapterCell.self, forCellReuseIdentifier: "ChapterCell")
    }
    
    private func setupConstraints() {
        
    }
    
    private func applyPalette(palette: UIImageColors?) {
        UIView.transition(with: self.view, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            if let palette = palette {
                self.tableView.separatorColor = palette.primary.withAlphaComponent(0.2)
                self.tableView.reloadData()
//                self.tableView.visibleCells.forEach({ (cell) in
//                    let chapterCell = cell as! ChapterCell
//                    chapterCell.palette = palette
//                    chapterCell.setupColors()
//                    chapterCell.backgroundColor = .red
//                })
            }
            else {
                self.tableView.separatorColor = nil
            }
        }, completion: nil)
    }
}
