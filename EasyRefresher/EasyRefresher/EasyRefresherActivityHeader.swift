//
//  EasyRefresherActivityHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/9.
//

import UIKit

/**
 * UIView.animate 在动画过程中默认已关闭了所有UI交互
 */



/**
 * 默认样式
 *         1. activity
 *         2. 纯文本
 *         3. 1 + 2， 刷新中的状态是1
 *         4. 波纹
 *
 * tip
 *         1. 记录开始拖拽的偏移量
 *         2. 松手后关闭scrollView的交互(验证默认已经是这种效果)
 */


class EasyRefresherActivityHeader: EasyRefresherHeader {

    lazy var activityView: EasyActivityIndicatorView = {
        let activityView = EasyActivityIndicatorView()
        addSubview(activityView)
        return activityView
    }()
    
    let selfMaxHeight = CGFloat(45)
    let activityMaxHeight = CGFloat(30)
    lazy var activityViewBottom = selfMaxHeight - activityMaxHeight
    
    
        
    /// 进入刷新状态
    override func beginRefreshing() {
        super.beginRefreshing()
        if state == .refreshing {
            return
        }
        state = .refreshing
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.scrollView!.contentInset.top += self.selfMaxHeight
                self.updateStateUI()
            }
        }
    }

    /// 结束刷新状态
    override func endRefreshing() {
        super.endRefreshing()
        if state != .refreshing {
            return
        }
        state = .idle
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.scrollView!.contentInset.top -= self.selfMaxHeight
                self.updateStateUI()
            }
        }
    }
    
    /// scrollView 偏移量 发生改变
    override func contentOffsetDidChange(_ offset: CGPoint) {
        if state == .refreshing {
            return
        }
        var insetT = scrollView!.contentInset.top
        if #available(iOS 11.0, *) {
            insetT += scrollView!.safeAreaInsets.top
        }
        scrolled = offset.y + insetT
        if -scrolled >= selfMaxHeight {
            state = .willRefreshing
        } else if -scrolled >= 0 {
            state = .pulling
        } else {
            state = .idle
        }
        updateStateUI()
    }
    
    /// 更新状态UI
    override func updateStateUI() {
        super.updateStateUI()
        let activityScaled: CGFloat
        let selfH: CGFloat

        if state == .idle {
            activityScaled = 0
            selfH = 0
        } else if state == .pulling {
            if -scrolled <= activityViewBottom {
                activityScaled = 0
            } else {
                activityScaled = (-scrolled - activityViewBottom) / activityMaxHeight
            }
            selfH = -scrolled
        } else {
            activityScaled = 1
            selfH = selfMaxHeight
        }
        activityView.frame.size = CGSize(width: activityMaxHeight * activityScaled,
                                         height: activityMaxHeight * activityScaled)
        activityView.drawUsingScale(activityScaled, length: activityMaxHeight)
        frame.size.height = selfH
        frame.origin.y = -selfH
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.center.x = frame.width * 0.5
    }
}
