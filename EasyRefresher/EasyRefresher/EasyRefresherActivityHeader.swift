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


let EasyRefresherDefaultHeight = CGFloat(54)
let EasyActivityDefaultHeight = CGFloat(30)


class EasyRefresherActivityHeader: EasyRefresherHeader {

    lazy var activityView: EasyActivityIndicatorView = {
        let activityView = EasyActivityIndicatorView()
        addSubview(activityView)
        return activityView
    }()
    let activityViewBottom = EasyRefresherDefaultHeight - EasyActivityDefaultHeight
        
    /// 进入刷新状态
    override func beginRefreshing() {
        super.beginRefreshing()
        if state == .refreshing {
            return
        }
        state = .refreshing
        UIView.animate(withDuration: 0.25) {
            self.scrollView!.contentInset.top = self.insetTBeforeRefreshing + EasyRefresherDefaultHeight
            self.updateStateUI()
        }
    }

    /// 结束刷新状态
    override func endRefreshing() {
        super.endRefreshing()
        if state != .refreshing {
            return
        }
        state = .idle
        UIView.animate(withDuration: 0.25) {
            self.scrollView!.contentInset.top = self.insetTBeforeRefreshing
            self.updateStateUI()
        }
    }
    
    /// scrollView 偏移量 发生改变
    override func contentOffsetDidChange(_ offset: CGPoint) {
        if state == .refreshing {
            return
        }
        insetTBeforeRefreshing = scrollView!.contentInset.top
        let scrolled = offset.y - offsetYBeforeDragging
        if -scrolled >= EasyRefresherDefaultHeight {
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
        let scrolled = scrollView!.contentOffset.y - offsetYBeforeDragging
        let activityScaled: CGFloat
        let selfY: CGFloat
        let selfH: CGFloat

        if state == .idle {
            activityScaled = 0
            selfY = -scrollView!.contentInset.top
            selfH = 0
        } else if state == .pulling {
            if -scrolled <= activityViewBottom {
                activityScaled = 0
            } else {
                activityScaled = (-scrolled - activityViewBottom) / EasyActivityDefaultHeight
            }
            selfY = scrolled - scrollView!.contentInset.top
            selfH = -scrolled
        } else {
            activityScaled = 1
            selfY = -EasyRefresherDefaultHeight - insetTBeforeRefreshing
            selfH = EasyRefresherDefaultHeight
        }
        activityView.frame.size = CGSize(width: EasyActivityDefaultHeight * activityScaled,
                                         height: EasyActivityDefaultHeight * activityScaled)
        activityView.drawUsingScale(activityScaled)
        frame.size.height = selfH
        frame.origin.y = selfY
    }
    
    
    override func scrollViewFrameDidChange(_ sFrame: CGRect) {
        super.scrollViewFrameDidChange(sFrame)
        frame.size.height = EasyRefresherDefaultHeight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.center.x = frame.width * 0.5
    }
}
