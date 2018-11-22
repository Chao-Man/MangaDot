//
//  ReaderScrobblerViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 18/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import SnapKit
import UIKit

class ReaderScrobblerViewController: UIViewController {
    // MARK: - Types

    // MARK: - Properties

    let collectionViewLayout = UICollectionViewFlowLayout()
    let collectionViewController: UICollectionViewController
    let separatorView = SeparatorView(axis: .horizontal, width: 0.5, inset: 0, color: UIColor.gray)
    let visualEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
    let visualEffectsView: UIVisualEffectView

    // MARK: - View Life Cycle

    init() {
        collectionViewController = UICollectionViewController(collectionViewLayout: collectionViewLayout)
        visualEffectsView = UIVisualEffectView(effect: visualEffect)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        setupChildViewcontrollers()
        setupViews()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func updateViewConstraints() {
        visualEffectsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }

        super.updateViewConstraints()
    }

    // MARK: - Helper Methods

    private func setupChildViewcontrollers() {
        collectionViewController.collectionView.delegate = self
        collectionViewController.collectionView.dataSource = self

        collectionViewController.willMove(toParent: self)
        addChild(collectionViewController)
    }

    private func setupViews() {
        visualEffectsView.clipsToBounds = true;
        
        collectionViewController.collectionView.backgroundColor = .clear
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collectionViewLayout.scrollDirection = .horizontal

        view.addSubview(visualEffectsView)
        visualEffectsView.contentView.addSubview(collectionViewController.view)
        visualEffectsView.contentView.addSubview(separatorView)
        
        updateViewConstraints()
    }
}

extension ReaderScrobblerViewController: UICollectionViewDelegate {}

extension ReaderScrobblerViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 0
    }

    func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
