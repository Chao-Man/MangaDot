//
//  TitleViewController.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class TitleViewController: UIViewController {
    
    // MARK: - Types
    private enum AlertType {
        case noTitleDataAvailable
    }
    
    // MARK: - Properties
    let scrollView            = UIScrollView()
    let containerView         = UIView()
    let imageView             = UIImageView()
    let imageContainerView    = UIView()
    let titleView             = UILabel()
    let creatorsContainerView = UIView()
    let authorHeaderView      = UILabel()
    let artistHeaderView      = UILabel()
    let authorView            = UILabel()
    let artistView            = UILabel()
    let descriptionView       = UILabel()
    let descriptionStyle      = NSMutableParagraphStyle()
    let cornerRadius: CGFloat = 10.0
    
    private let chapterViewController = ChapterViewController()
    
    var palette: UIImageColors? {
        didSet {
            self.applyPalette(palette: palette)
        }
    }
    
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
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.applyPalette(palette: self.palette)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.applyPalette(palette: nil)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.applyPalette(palette: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupShadows()
        setupChildViewControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    private func setupViews() {
        // Customise view
        self.view.backgroundColor = .white
        
        // Init sub views
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imageContainerView)
        containerView.addSubview(titleView)
        containerView.addSubview(creatorsContainerView)
        containerView.addSubview(descriptionView)
        imageContainerView.addSubview(imageView)
        
        // Setup ScrollView
        scrollView.alwaysBounceVertical         = true
        scrollView.showsVerticalScrollIndicator = false
        
        // Setup CoverView
        imageView.kf.indicatorType              = .activity
        imageView.backgroundColor               = .white
        imageView.contentMode                   = .scaleAspectFill
        imageView.layer.magnificationFilter     = .trilinear
        imageView.layer.minificationFilter      = .trilinear
        imageView.clipsToBounds                 = true
        imageView.layer.cornerRadius            = cornerRadius
        imageView.layer.shouldRasterize         = true
        imageView.layer.rasterizationScale      = UIScreen.main.scale
        
        // Setup TitleView
        titleView.font                          = UIFont.MangaDot.boldLarge
        titleView.numberOfLines                 = 3
        
        // Setup DescriptionView
        descriptionView.font                    = UIFont.MangaDot.regularSmall
        descriptionView.lineBreakMode           = .byWordWrapping
        descriptionView.numberOfLines           = 5
        
        // Setup Description Style
        descriptionStyle.lineSpacing = 1.4
        descriptionStyle.lineBreakMode = .byTruncatingTail
    }
    
    private func setupConstraints() {
        
        // ScrollView Constraints
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top
                .equalTo(self.view)
            make.bottom
                .equalTo(self.view)
            make.left
                .equalTo(self.view)
            make.width
                .equalTo(self.view.snp.width)
                .dividedBy(3)
        }
        
        // ContainerView Constraints
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges
                .equalToSuperview()
            make.width
                .equalToSuperview()
        }
        
        // CoverContainer Constraints
        imageContainerView.snp.makeConstraints { (make) -> Void in
            make.top
                .equalToSuperview()
                .offset(10)
            make.left
                .equalToSuperview()
                .offset(10)
            make.width
                .equalToSuperview()
                .inset(10)
            make.height
                .equalTo(imageContainerView.snp.width)
                .multipliedBy(1.4222)
        }
        
        // Cover Constraints
        imageView.snp.makeConstraints { (make) -> Void in
            make.top
                .equalTo(imageContainerView)
            make.bottom
                .equalTo(imageContainerView)
            make.left
                .equalTo(imageContainerView)
            make.right
                .equalTo(imageContainerView)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top
                .equalTo(imageContainerView.snp.bottom).offset(10)
            make.left
                .equalTo(imageContainerView)
            make.width
                .equalTo(imageContainerView)
        }

        descriptionView.snp.makeConstraints { (make) in
            make.top
                .equalTo(titleView.snp.bottom).offset(5)
            make.left
                .equalTo(titleView)
            make.width
                .equalTo(imageContainerView)
            make.bottom
                .equalToSuperview().offset(-20)
        }
        
        titleView.sizeToFit()
        descriptionView.sizeToFit()
    }
    
    private func setupShadows() {
        imageContainerView.layer.cornerRadius       = cornerRadius
        imageContainerView.layer.applySketchShadow(
            color: .black,
            alpha: 0.2,
            x: 0,
            y: 1,
            blur: 5,
            spread: 0
        )
        imageContainerView.layer.shouldRasterize    = true
        imageContainerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupChildViewControllers() {
        addChild(chapterViewController)
        
        view.addSubview(chapterViewController.view)
        
        // Constraints
        chapterViewController.view.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
            make.left
                .equalTo(scrollView.snp.right).offset(20)
            make.right
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
        }
        
        chapterViewController.willMove(toParent: self)
    }
    
    private func loadData(with viewModel: TitleViewModel) {
        let setupColorTheme: (UIImage?, NSError?, CacheType, URL?) -> Void = {
            [weak self] (image: UIImage?, error: NSError?, cacheType: CacheType, imageUrl: URL?) in
            if let image = image {
                image.getColors() { colors in
                    self?.palette = colors
                }
            }
        }
        
        viewModel.didfetchTitleData = { [weak self] (titleData, error) in
            if let _ = error {
                self?.presentAlert(of: .noTitleDataAvailable)
            }
            else if let titleData = titleData {
                DispatchQueue.main.async {
                    // Update strings
                    self?.titleView.text = String(htmlEncodedString: titleData.title)
                    let descriptionText = String(htmlEncodedString: titleData.description)
                    self?.setDescription(description: descriptionText)
                    
                    // Update Chapter View Controller
                    let chapterViewModel = ChapterViewModel(titleData: titleData)
                    self?.chapterViewController.viewModel = chapterViewModel
                    
                    // Fetch Image
                    if let largeCoverUrl = titleData.largeCoverUrl {
                        self?.imageView.kf.setImage(with: largeCoverUrl, completionHandler: setupColorTheme)
                    }
                    else {
                        self?.imageView.kf.setImage(with: titleData.coverUrl, completionHandler: setupColorTheme)
                    }
                    
                }
            }
        }
    }
    
    private func setImageView(coverUrl: URL, largeCoverUrl: URL?, imageView: UIImageView) {
        // Load high resolution image if exists
        if let largeCoverUrl = largeCoverUrl {
            // Load low resolution thumbnail as placeholder
            let thumbnail = UIImageView()
            thumbnail.kf.setImage(with: coverUrl)
            thumbnail.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: largeCoverUrl, placeholder: thumbnail as Placeholder, options: [], progressBlock: nil, completionHandler: nil)
        }
            // Otherwise use low resolution thumbnail
        else {
            imageView.kf.setImage(with: coverUrl)
        }
    }
    
    private func applyPalette(palette: UIImageColors?) {
        UIView.transition(with: self.view, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            // Set TableViewController palette
            self.chapterViewController.palette = palette
            
            if let palette = palette {
                // Set background color
                self.view.backgroundColor                                    = palette.background
                // Set Navigation bar background color
                self.navigationController?.navigationBar.barTintColor        = palette.background
                // Set Navigation translucent
                self.navigationController?.navigationBar.isTranslucent       = true
                // Set Status bar color to bright/dark depending on background. Light text on dark bg, black text on light bg.
                self.navigationController?.navigationBar.barStyle            = palette.background.barStyle
                // Set Navigation bar item color, Back button, etc
                self.navigationController?.navigationBar.tintColor           = palette.primary
                // Set Navigation bar title text color
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: palette.primary
                ]
                // Set Tab bar background color
                self.tabBarController?.tabBar.barTintColor                   = palette.background.withAlphaComponent(0.7)
                // Set Tab bar currently selected item color
                self.tabBarController?.tabBar.tintColor                      = palette.primary
                // Set title view text color
                self.titleView.textColor                                     = palette.primary
                // Set description view text color
                self.descriptionView.textColor                               = palette.secondary
                
            }
            else {
                self.view.backgroundColor                                    = .white
                self.navigationController?.navigationBar.barTintColor        = nil
                self.navigationController?.navigationBar.barStyle            = .default
                self.navigationController?.navigationBar.tintColor           = nil
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ]
                self.tabBarController?.tabBar.barTintColor                   = nil
                self.tabBarController?.tabBar.tintColor                      = nil
                
                self.titleView.textColor       = .black
                self.descriptionView.textColor = .black
                
            }
        }, completion: nil)
    }
    
    private func setDescription(description: String?) {
        guard let description = description else {
            return
        }
        
        let attrString = NSMutableAttributedString(string: description)
        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: descriptionStyle,
            range: NSMakeRange(
                0,
                attrString.length
            )
        )
        self.descriptionView.attributedText = attrString
    }
    
    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String
        
        switch alertType {
        case .noTitleDataAvailable:
            title = "Unable to Fetch Title Data"
            message = "The application is unable to fetch weather data. Please make sure your device is connected over Wi-Fi or cellular."
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
