//
//  TitleViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//
import SnapKit
import UIKit

class TitleViewController: PalettableViewController {
    // MARK: - Types

    private enum AlertType {
        case noTitleDataAvailable
    }

    // MARK: - Properties

    private let chapterViewController = TitleChapterViewController()
    private let descriptionViewController = TitleDescriptionViewController()
    private let separatorView = SeparatorView(
        axis: .vertical,
        width: 0.5,
        inset: 10,
        color: UIColor.MangaDot.lightGray
    )

    var viewModel: TitleViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            loadData(with: viewModel)
            viewModel.fetchMangadexTitleData()
        }
    }

    // MARK: - View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        applyPalette(palette: palette)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        applyPalette(palette: MangaDot.Pallete.lightTheme)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupChildViewControllers()
    }

    override func viewDidLayoutSubviews() {
        updateViewConstraints()
        super.viewDidLayoutSubviews()
    }

    override func updateViewConstraints() {
        descriptionViewController.view.snp.makeConstraints { make in
            make.top
                .left
                .bottom
                .equalToSuperview()
            make.width
                .equalToSuperview()
                .multipliedBy(0.4)
        }
        separatorView.snp.makeConstraints { make in
            make.top
                .equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom
                .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width
                .equalTo(1)
            make.left
                .equalTo(descriptionViewController.view.snp.right)
        }
        chapterViewController.view.snp.makeConstraints { make in
            make.top
                .right
                .bottom
                .equalToSuperview()
            make.left
                .equalTo(separatorView.snp.right)
                .offset(10)
        }
        super.updateViewConstraints()
    }

    // MARK: - Helper Methods

    private func setupViews() {
        // Customise view
        view.addSubview(separatorView)
        view.backgroundColor = .white
        // Remove back button title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupChildViewControllers() {
        addChild(descriptionViewController)
        addChild(chapterViewController)

        view.addSubview(descriptionViewController.view)
        view.addSubview(chapterViewController.view)

        descriptionViewController.willMove(toParent: self)
        chapterViewController.willMove(toParent: self)
    }

    private func loadData(with viewModel: TitleViewModel) {
        viewModel.didfetchTitleData = { [weak self] titleData, error in
            if let _ = error {
                self?.presentAlert(of: .noTitleDataAvailable)
            } else if let titleData = titleData {
                // Update Chapter View Controller
                let chapterViewModel = TitleChapterViewModel(titleData: titleData)
                self?.chapterViewController.viewModel = chapterViewModel
                // Update Description View Controller
                let descriptionViewModel = TitleDescriptionViewModel(titleData: titleData)
                self?.descriptionViewController.viewModel = descriptionViewModel
            }
        }
    }

    override func applyPalette(palette: ColorPalette) {
        super.applyPalette(palette: palette)
//        UIView.transition(with: view, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
//            // Set TableViewController palette
//            self.chapterViewController.palette = palette
//
//            if let palette = palette {
//                // Set background color
//                self.view.backgroundColor = palette.background
//                // Set Navigation bar background color
//                self.navigationController?.navigationBar.barTintColor = palette.background
//                // Set Navigation translucent
//                self.navigationController?.navigationBar.isTranslucent = true
//                // Set Status bar color to bright/dark depending on background. Light text on dark bg, black text on light bg.
//                self.navigationController?.navigationBar.barStyle = palette.background.barStyle
//                // Set Navigation bar item color, Back button, etc
//                self.navigationController?.navigationBar.tintColor = palette.primary
//                // Set Navigation bar title text color
//                self.navigationController?.navigationBar.titleTextAttributes = [
//                    NSAttributedString.Key.foregroundColor: palette.primary,
//                ]
//                // Set Tab bar background color
//                self.tabBarController?.tabBar.barTintColor = palette.background.withAlphaComponent(0.7)
//                // Set Tab bar currently selected item color
//                self.tabBarController?.tabBar.tintColor = palette.primary
//                // Set title view text color
//                self.titleView.textColor = palette.primary
//                // Set description view text color
//                self.descriptionView.textColor = palette.secondary
//            } else {
//                self.view.backgroundColor = .white
//                self.navigationController?.navigationBar.barTintColor = nil
//                self.navigationController?.navigationBar.barStyle = .default
//                self.navigationController?.navigationBar.tintColor = nil
//                self.navigationController?.navigationBar.titleTextAttributes = [
//                    NSAttributedString.Key.foregroundColor: UIColor.black,
//                ]
//                self.tabBarController?.tabBar.barTintColor = nil
//                self.tabBarController?.tabBar.tintColor = nil
//
//                self.titleView.textColor = .black
//                self.descriptionView.textColor = .black
//            }
//        }, completion: nil)
    }

    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String

        switch alertType {
        case .noTitleDataAvailable:
            title = "Unable to Fetch Title Data"
            message = "The application is unable to fetch manga data. Please make sure your device is connected over Wi-Fi or cellular."
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
