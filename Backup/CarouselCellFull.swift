    var id: Int?
    var imageView = UIImageView()
    var innerContainerView = UIView()
    var outerContainerView = UIView()
    var titleView = UILabel()
    
    func setup(titleData: TitleData) {
        id = titleData.id
        
        // Add Subviews
        self.addSubview(outerContainerView)
        outerContainerView.addSubview(innerContainerView)
        innerContainerView.addSubview(imageView)
        innerContainerView.addSubview(titleView)
        
        // Configure Outer Container View
        outerContainerView.layer.cornerRadius = 8.0
        outerContainerView.backgroundColor = .white
        outerContainerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 5, blur: 20, spread: 0)
        
        // Set Outer Container View Constraints
        outerContainerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        // Configure Inner Container View
        innerContainerView.layer.cornerRadius = 8.0
        innerContainerView.clipsToBounds = true
        
        // Set Inner Container View Constraints
        innerContainerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(outerContainerView)
            make.bottom.equalTo(outerContainerView)
            make.left.equalTo(outerContainerView)
            make.right.equalTo(outerContainerView)
        }
        
        // Configure Image View
        imageView.contentMode = .scaleAspectFill
        imageView.kf.setImage(with: titleData.coverUrl)
        imageView.clipsToBounds = true
        
        // Set Image View Constraints
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(innerContainerView)
            make.left.equalTo(innerContainerView)
            make.width.equalTo(innerContainerView)
            make.height.equalTo(innerContainerView.snp.width).multipliedBy(1.42)
        }
        
        // Configure Title View
        titleView.font = UIFont.MangaDot.mediumSmall
        titleView.text = titleData.title
        
        // Set Title View Constraints
        titleView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(innerContainerView)
            make.left.equalTo(innerContainerView).offset(5)
            make.right.equalTo(innerContainerView).offset(-5)
        }