//
//  EasyRefresherActivityHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/9.
//

import UIKit



enum EasyRefresherState {
    case idl, pulling, willRefreshing, refreshing
}

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

class EasyRefresherActivityHeader: UIView {

    lazy var activityView: EasyActivityIndicatorView = {
        let activityView = EasyActivityIndicatorView()
        addSubview(activityView)
        return activityView
    }()
    
    var offsetYBeforeDragging: CGFloat = 0
    weak var scrollView: UIScrollView?
    let activityViewBottom = EasyRefresherDefaultHeight - EasyActivityDefaultHeight
    
    var state = EasyRefresherState.idl
    
    override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        superviewMustBeScrollView()
        addObserves()
    }
    
    func beginRefresh() {
        if state == .refreshing {
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset.top += self.frame.height
            self.scrollView?.contentOffset.y -= EasyRefresherDefaultHeight
        } completion: { (_) in
            self.state = .refreshing
            UIView.animate(withDuration: 0.25) {
//                self.scrollView?.contentInset.top += self.frame.height
            } completion: { (_) in
                
            }
        }
    }
    
    /// 父组件必须是UIScrollView(包含子类)
    func superviewMustBeScrollView() {
        scrollView = superview as? UIScrollView
        let isScrollView = superview == nil || superview != nil && superview is UIScrollView
        assert(isScrollView, "必须是UIScrollView(或者子类)")
    }
    
    /// 注册监听
    func addObserves() {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: "frame", options: [.initial, .new], context: nil)
        let pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: "state", options: .new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" {
            contentOffsetDidChange(change![.newKey] as! CGPoint)
            return
        }
        if keyPath == "frame" {
            scrollViewFrameDidChange(change![.newKey] as! CGRect)
            return
        }
        if keyPath == "state" {
            let state = UIGestureRecognizer.State(rawValue: change![.newKey] as! Int)!
            panSateDidChange(state)
            return
        }
    }

    /// scrollView 偏移量 发生改变
    func contentOffsetDidChange(_ offset: CGPoint) {
        if state == .refreshing {
            return
        }
        let scrolled = offset.y - offsetYBeforeDragging
        print(offset.y, offsetYBeforeDragging)
        var scale: CGFloat = 0
        if scrolled <= 0 {
            frame.size.height = min(-scrolled, EasyRefresherDefaultHeight)
            if -scrolled > activityViewBottom {
                scale = (-scrolled - activityViewBottom) / EasyActivityDefaultHeight
                if scale > 1 {
                    scale = 1
                }
            }
            if -scrolled >= EasyRefresherDefaultHeight {
                state = .willRefreshing
            } else {
                state = .pulling
            }
        } else {
            frame.size.height = EasyRefresherDefaultHeight
            state = .idl
        }
        activityView.drawUsingScale(scale)
        frame.origin.y = max(scrolled, -frame.height) + offsetYBeforeDragging
    }
    
    /// scrollView frame 发生改变
    func scrollViewFrameDidChange(_ sFrame: CGRect) {
        frame.size.width = sFrame.width
    }
    
    /// scrollView 拖拽手势状态 发生改变
    func panSateDidChange(_ state: UIGestureRecognizer.State) {
        if state == .began {
            offsetYBeforeDragging = scrollView!.contentOffset.y
        } else if state == .ended {
            if self.state == .willRefreshing {
                self.state = .refreshing
                UIView.animate(withDuration: 0.25) {
                    self.scrollView?.contentInset.top += self.frame.height
                } completion: { (_) in
                    
                }
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.center.x = frame.width * 0.5
    }
}
