//
//  MediaZoomTransitionDelegate.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/6/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol ZoomingViewController
{
    func zoomingImageView( for transition: MediaZoomTransitionDelegate) -> UIImageView?
    func zoomingBackgroundView( for transition: MediaZoomTransitionDelegate) -> UIView?
}

enum TransitionState
{
    case initial
    case final
}

class MediaZoomTransitionDelegate: NSObject
{
    var transitionDuration = 0.5
    var operation: UINavigationControllerOperation = .none
    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(0.7)
    
    typealias ZoomingViews = (otherView: UIView, imageView: UIView)
    
    func configureViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews){
        switch state {
        case .initial:
            backgroundViewController.view.transform = CGAffineTransform.identity
            backgroundViewController.view.alpha = 1
            
            snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, to: viewsInBackground.imageView.superview)
            
        case .final:
            backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
            backgroundViewController.view.alpha = 0
            
            snapshotViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
    }
}

extension MediaZoomTransitionDelegate : UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        var backgroundVC = fromVC
        var foregroundVC = toVC
        
        if operation == .pop {
            backgroundVC = toVC
            foregroundVC = fromVC
        }
        
        let maybeBackgroundImageView = (backgroundVC as? ZoomingViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundVC as? ZoomingViewController)?.zoomingImageView(for: self)
        
        assert(maybeBackgroundImageView != nil, "Cannot find imageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Cannot find imageView in foregroundVC")
        
        let backgroundIV = maybeBackgroundImageView!
        let foregroundIV = maybeForegroundImageView!
        
        let imageViewSnapshot = UIImageView(image: backgroundIV.image)
        imageViewSnapshot.contentMode = .scaleAspectFit
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundIV.isHidden = true
        foregroundIV.isHidden = true
        let foregroundViewBackgroundColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == .pop {
            preTransitionState = TransitionState.final
            postTransitionState = TransitionState.initial
        }
        
        configureViews(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundVC, viewsInBackground: (backgroundIV, backgroundIV), viewsInForeground: (foregroundIV, foregroundIV), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            
                self.configureViews(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundVC, viewsInBackground: (backgroundIV, backgroundIV), viewsInForeground: (foregroundIV, foregroundIV), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
            
        }) { (finished) in
         
            backgroundVC.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            backgroundIV.isHidden = false
            foregroundIV.isHidden = false
            foregroundVC.view.backgroundColor = foregroundViewBackgroundColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

extension MediaZoomTransitionDelegate: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        } else {
            return nil
        }
    }
}
