//
//  TitlePresentAnimationController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import PromiseKit
import PMKUIKit

class TitlePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let titleInfoSideBarPlaceholderView: UIView = {
        let view = UIView()
        view.backgroundColor = MangaDot.Color.white
        return view
    }()
    private let titleInfoMainPlaceholderView: UIView = {
        let view = UIView()
        view.backgroundColor = MangaDot.Color.whiteGray
        return view
    }()
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    private let fromCoverView: ShadowCoverView
    
    init(fromCoverView: ShadowCoverView) {
        self.fromCoverView = fromCoverView
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? TitleInfoContainerViewController else { return }
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? FeedViewController else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        toViewController.view.alpha = 0.0
        
        // Updates constraints for toViewController

        toViewController.view.layoutIfNeeded()
        toViewController.titleInfoSideBarViewController.view.layoutIfNeeded()
        
        // Snapshot of cover
        guard let toCoverViewSnapShot = toViewController.titleInfoSideBarViewController.coverView.snapshotView(afterScreenUpdates: true) else { return }

        // Set initial location, convert frame to fromViewController coordinate space
        toCoverViewSnapShot.frame = fromViewController.view.convert(fromCoverView.frame, from: fromCoverView)
        
        // Hide original cover
        fromCoverView.isHidden = true
        
        containerView.addSubview(toCoverViewSnapShot)
        
        let localToCoverViewFrame = toViewController.titleInfoSideBarViewController.coverView.frame
        let toCoverViewFrame = toViewController.view.convert(localToCoverViewFrame, from: toViewController.titleInfoSideBarViewController.containerStackview)
        
        // Add placeholder views
        titleInfoSideBarPlaceholderView.frame = toCoverViewFrame
        titleInfoMainPlaceholderView.frame = toViewController.titleInfoSideBarViewController.view.frame
        containerView.insertSubview(titleInfoSideBarPlaceholderView, belowSubview: toViewController.view)
        containerView.insertSubview(titleInfoMainPlaceholderView, belowSubview: titleInfoSideBarPlaceholderView)
        titleInfoSideBarPlaceholderView.isHidden = true
        titleInfoMainPlaceholderView.isHidden = true
        
        // Add blur view
        blurView.alpha = 0.0
        blurView.frame = containerView.frame
        containerView.insertSubview(blurView, belowSubview: titleInfoMainPlaceholderView)
        
        let duration = transitionDuration(using: transitionContext)
        
        // Background blur animation
        UIView.animate(withDuration: duration * 0.25) {
            self.blurView.alpha = 1.0
        }
        
        // Main cover animation
        firstly {
            UIView.animate(
                .promise,
                duration: duration * 0.375,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.0,
                animations: {
                    toCoverViewSnapShot.frame = toCoverViewFrame
            })
        }.then {_ in
            UIView.animate(
                .promise,
                duration: duration * 0.125,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.0,
                animations: {
                    self.titleInfoSideBarPlaceholderView.isHidden = false
                    self.titleInfoSideBarPlaceholderView.frame = toViewController.titleInfoSideBarViewController.view.frame
            })
        }.then {_ in
            UIView.animate(
                .promise,
                duration: duration * 0.125,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.0,
                animations: {
                    self.titleInfoMainPlaceholderView.isHidden = false
                    self.titleInfoMainPlaceholderView.frame = toViewController.titleInfoMainViewController.view.frame
            })
        }.then {_ in
            UIView.animate(.promise, duration: duration * 0.25, animations: {
                toViewController.view.alpha = 1.0
            })
        }.then{_ in
            UIView.animate(.promise, duration: duration * 0.125, animations: {
                toCoverViewSnapShot.alpha = 0.0
            })
        }.done {_ in
            self.fromCoverView.isHidden = false
            toCoverViewSnapShot.removeFromSuperview()
            self.blurView.removeFromSuperview()
            self.titleInfoSideBarPlaceholderView.removeFromSuperview()
            self.titleInfoMainPlaceholderView.removeFromSuperview()
            self.fromCoverView.layer.transform = CATransform3DIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
