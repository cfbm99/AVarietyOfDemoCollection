//
//  CFPhotoBrowseTransitionAnimation.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

enum CFPhotoBrowseTransitionAnimationStyle: Int {
    case present, dismiss
}

class CFPhotoBrowseTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var style: CFPhotoBrowseTransitionAnimationStyle
    
    init(transitionstyle: CFPhotoBrowseTransitionAnimationStyle) {
        style = transitionstyle
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if style == .present {
            presentVcTransition(using: transitionContext)
        } else {
            dismissVcTransition(using: transitionContext)
        }
    }
}

extension CFPhotoBrowseTransitionAnimation {
    
    fileprivate func presentVcTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let nav = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
            let fromVc = nav.viewControllers.last as? NationalGeographyViewController,
            let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? CFPhotoBrowseViewController,
            let toVcCurrentImgV = toVc.currentImageV else { transitionContext.completeTransition(true); return }
        
        let tempImgV = UIImageView(image: fromVc.currentImgV.image)
        tempImgV.clipsToBounds = true
        tempImgV.contentMode = .scaleAspectFill
        let containerView = transitionContext.containerView
        
        let fromRect = fromVc.currentImgV.convert(fromVc.currentImgV.bounds, to: containerView)
        let toRect = toVcCurrentImgV.convert(toVcCurrentImgV.bounds, to: containerView)
        tempImgV.frame = fromRect
        toVc.view.alpha = 0
        toVcCurrentImgV.isHidden = true
        containerView.addSubview(toVc.view)
        containerView.addSubview(tempImgV)
        fromVc.currentImgV.isHidden = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            tempImgV.frame = toRect
            toVc.view.alpha = 1
        }) { (finish) in
            toVcCurrentImgV.isHidden = false
            tempImgV.removeFromSuperview()
            fromVc.currentImgV.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    fileprivate func dismissVcTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CFPhotoBrowseViewController,
            let nav = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController,
            let toVc = nav.viewControllers.last as? NationalGeographyViewController,
            let fromVcCurrentImgV = fromVc.currentImageV,
            let toVcCell = toVc.currentCollectionView.cellForItem(at: IndexPath(item: fromVc.currentIdx, section: 0)) as? NationalGeographyCollectionViewCell else { transitionContext.completeTransition(true); return }
        
        let tempImgV = UIImageView(image: fromVcCurrentImgV.image)
        tempImgV.clipsToBounds = true
        tempImgV.contentMode = .scaleAspectFill
        let containerView = transitionContext.containerView
        
        let fromRect = fromVcCurrentImgV.convert(fromVcCurrentImgV.bounds, to: containerView)
        let toRect = toVcCell.convert(toVcCell.imageV.frame, to: containerView)
        tempImgV.frame = fromRect
        toVcCell.isHidden = true
        containerView.addSubview(tempImgV)
        fromVc.currentImageV?.isHidden = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            tempImgV.frame = toRect
            fromVc.view.alpha = 0
        }) { (finish) in
            toVcCell.isHidden = false
            tempImgV.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
