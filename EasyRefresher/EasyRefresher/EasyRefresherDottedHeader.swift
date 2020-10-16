//
//  EasyRefresherDottedHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/12.
//

import Foundation
import UIKit




class EasyRefresherDottedHeader: EasyRefresherHeader {

    let dotViewAnimtionKey = "dotViewAnimtionKey"
    lazy var dotA = createDotView(99)
    lazy var dotB = createDotView(100)
    lazy var dotC = createDotView(101)
    lazy var dots = [dotA, dotB, dotC]
    let dotHeight = CGFloat(10)
    lazy var dotBottom = (frame.height - dotHeight) * 0.5
    

    override init(_ action: @escaping EasyRefresherAction) {
        super.init(action)
        frame.size.height = 40
    }
        
    var animateTimer: CADisplayLink?
    
    override func beginRefreshing() {
        super.beginRefreshing()
        if state == .refreshing {
            return
        }
        state = .refreshing
        resizeDotViewsAnimated()
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset.top = self.insetTBeforeRefreshing + self.frame.height
            self.updateStateUI()
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        if state != .refreshing {
            return
        }
        state = .idle
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset.top = self.insetTBeforeRefreshing
        }
    }
    
    
    override func contentOffsetDidChange(_ offset: CGPoint) {
        super.contentOffsetDidChange(offset)
        if state == .refreshing {
            return
        }
        insetTBeforeRefreshing = scrollView!.contentInset.top
        var top = scrollView!.contentInset.top
        if #available(iOS 11.0, *) {
            top += scrollView!.safeAreaInsets.top
        }
        scrolled = scrollView!.contentOffset.y + top
        if -scrolled > frame.height {
            state = .willRefreshing
        } else if -scrolled > 0 {
            state = .pulling
        } else {
            state = .idle
        }
        updateStateUI()
    }
    
    
    override func updateStateUI() {
        let dotScaled: CGFloat
        if state == .idle {
            dotScaled = 0
            removeDotViewsAnimtion()
        } else if state == .pulling {
            if -scrolled > dotBottom {
                dotScaled = min(1, (-scrolled - dotBottom) / dotA.frame.maxY)
            } else {
                dotScaled = 0
            }
            removeDotViewsAnimtion()
        } else {
            dotScaled = 1
            resizeDotViewsAnimated()
        }
        resizeDotViewsUsingScale(dotScaled)
    }
    
    /// 创建dotView
    func createDotView(_ tag: Int) -> UIView {
        let dotView = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: dotHeight,
                                           height: dotHeight))
        dotView.layer.cornerRadius = dotHeight * 0.5
        dotView.clipsToBounds = true
        dotView.transform = CGAffineTransform(scaleX: 0, y: 0)
        dotView.tag = tag
        dotView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        addSubview(dotView)
        return dotView
    }
    
    
    /// dotViews 的位置
    func positionDotViews() {
        for dot in dots {
            dot.center.y = frame.height * 0.5
            dot.center.x = frame.width * 0.5 - CGFloat(100 - dot.tag) * 18
        }
    }
    
    /// 缩放 dotViews
    func resizeDotViewsUsingScale(_ scale: CGFloat) {
        assert(scale <= 1 && scale >= 0)
        dotA.transform = CGAffineTransform(scaleX: scale, y: scale)
        let bScale = max(0, scale - 0.4) * 10 / 6
        dotB.transform = CGAffineTransform(scaleX: bScale, y: bScale)
        let cScale = max(0, scale - 0.7) * 10 / 3
        dotC.transform = CGAffineTransform(scaleX: cScale, y: cScale)
    }
    
    /// 动画缩放 dotViews
    func resizeDotViewsAnimated() {
        if dotA.layer.animation(forKey: dotViewAnimtionKey) != nil {
            return
        }
        let delays = [0, 0.15, 0.1]
        for (index, dot) in dots.enumerated() {
            let anim = CABasicAnimation(keyPath: "transform.scale")
            anim.fromValue = 1
            anim.toValue = 0
            anim.autoreverses = true
            anim.duration = 0.5
            anim.timeOffset = delays[index]
            anim.repeatCount = Float.infinity
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
            dot.layer.add(anim, forKey: dotViewAnimtionKey)
        }
    }
    
    /// 移除 dotViews 动画
    func removeDotViewsAnimtion() {
        for dot in dots {
            dot.layer.removeAnimation(forKey: dotViewAnimtionKey)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        positionDotViews()
    }
    
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame.size.height = frame.height
        frame.origin.y = -frame.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

