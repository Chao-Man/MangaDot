//
//  CarouselViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import SnapKit

class CarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    var viewModel: CarouselViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            // Setup View Model
            setupViewModel(with: viewModel)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViewModel(with viewModel: CarouselViewModel) {
        
    }
    
    // MARK: - Helper Methods
    private func setupViews() {

        // Initalise collection layout
        let layout = UICollectionViewFlowLayout()
        
        // Initialise views
        let headerView = UILabel()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        // Add Subviews
        view.addSubview(headerView)
        view.addSubview(collectionView)
        
        // Calculate appropriate cell dimensions
//        let itemHeight = UIScreen.main.bounds.height * 0.1
//        let itemWidth = itemHeight * 0.625
        
        // Setup Layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 135, height: 216)
        layout.scrollDirection = .horizontal
        
        // Setup View
        view.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(layout.itemSize.height + 70)
        }
        
        // Setup Header View
        headerView.text = viewModel?.sectionName().localized()
        headerView.font = UIFont.MangaDot.boldLarge
        
        // Setup Collection View
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        // Setup Header View Constraints
        headerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(10)
            make.left.equalTo(self.view).offset(20)
        }
        
        // Setup Collection View Constraints
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }
    
    // MARK: - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        return viewModel.numberOfTitles()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        
        carouselCell.recycle(titleData: self.viewModel!.titleData(index: indexPath.row))
        return carouselCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let pushTitle = viewModel?.pushTitle {
            let titleId = viewModel?.sectionData.titleList[indexPath.row].id
            let title = viewModel?.sectionData.titleList[indexPath.row].title
            pushTitle(titleId, title)
        }
    }
}
