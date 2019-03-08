//
//  TitleDismissAnimationController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta
import PromiseKit
import PMKUIKit

class TitleDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    private let toCoverView: ShadowCoverView
    let interactionController: SwipeInteractionController?
    
    init(toCoverView: ShadowCoverView, interactionController: SwipeInteractionController?) {
        self.toCoverView = toCoverView
        self.interactionController = interactionController
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? TitleInfoContainerViewController else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) as? FeedViewController else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        let fromCoverView = fromViewController.titleInfoSideBarViewController.coverView
        
        // Snapshot of cover
        guard let fromCoverViewSnapShot = fromCoverView.snapshotView(afterScreenUpdates: false) else { return }
        
        // Convert frame to FeedViewController coordinate space
        let toCoverViewFrame = toViewController.view.convert(toCoverView.frame, from: toCoverView.superview)
        let fromCoverViewFrame = fromViewController.view.convert(fromCoverView.frame, from: fromCoverView.superview)
        
        // Set initial location
        fromCoverViewSnapShot.frame = fromCoverViewFrame
        
        // Hide original cover
        fromCoverView.alpha = 0.0
        
        // Set destionation cover transparent
        toCoverView.alpha = 0.0
        
        
        // Add snapshot
        containerView.addSubview(fromCoverViewSnapShot)
        
        // Add blur view
        blurView.alpha = 1.0
        blurView.frame = containerView.frame
        containerView.insertSubview(blurView, belowSubview: fromViewController.view)
        
        let duration = transitionDuration(using: transitionContext)
        
        // Main cover animation
        firstly {
//            UIView.animate(
//                .promise,
//                duration: duration * 0.5,
//                delay: 0.0,
//                usingSpringWithDamping: 0.5,
//                initialSpringVelocity: 0.0,
//                animations: {
//                    fromCoverViewSnapShot.frame = toCoverViewFrame
//                    fromViewController.view.alpha = 0.0
//            })
            UIView.animate(.promise, duration: duration * 0.33, options: .curveEaseOut, animations: {
                fromCoverViewSnapShot.frame = toCoverViewFrame
                fromViewController.view.alpha = 0.0
            })
        }.then { _ in
            UIView.animate(.promise, duration: duration * 0.33, animations: {
                self.blurView.alpha = 0.0
                self.toCoverView.alpha = 1.0
                toViewController.view.alpha = 1.0
            })
        }.then{ _ in
            UIView.animate(.promise, duration: duration * 0.33, animations: {
                fromCoverViewSnapShot.alpha = 0.0
            })
        }.done { _ in
            fromViewController.view.alpha = 1.0
            fromCoverView.alpha = 1.0
            fromCoverViewSnapShot.removeFromSuperview()
            self.blurView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
