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


enum EasyRefresherstate {
    case idle, pulling, willRefreshing, refreshing
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

typealias EasyRefresherAction = () -> ()

class EasyRefresherActivityHeader: UIView {

    lazy var activityView: EasyActivityIndicatorView = {
        let activityView = EasyActivityIndicatorView()
        addSubview(activityView)
        return activityView
    }()
    
    var offsetYBeforeDragging: CGFloat = 0
    var insetTBeforeRefreshing: CGFloat = 0
    weak var scrollView: UIScrollView?
    let activityViewBottom = EasyRefresherDefaultHeight - EasyActivityDefaultHeight
        
    let action: EasyRefresherAction
    
    var state = EasyRefresherstate.idle {
        didSet {
            if state == .refreshing {
                action()
            }
        }
    }
    
    
    init(_ action: @escaping EasyRefresherAction) {
        self.action = action
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        superviewMustBeScrollView()
        addObserves()
    }
    
    /// 进入刷新状态
    func beginRefreshing() {
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
    func endRefreshing() {
        if state != .refreshing {
            return
        }
        state = .idle
        UIView.animate(withDuration: 0.25) {
            self.scrollView!.contentInset.top = self.insetTBeforeRefreshing
            self.updateStateUI()
        }
    }
    
    /// 父组件必须是UIScrollView(包含子类)
    func superviewMustBeScrollView() {
        scrollView = superview as? UIScrollView
        let isScrollView = superview == nil || superview != nil && superview is UIScrollView
        assert(isScrollView, "必须是UIScrollView(或者子类)")
        insetTBeforeRefreshing = scrollView!.contentInset.top
        frame.origin.y = -insetTBeforeRefreshing
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
            panStateDidChange(state)
            return
        }
    }

    /// scrollView 偏移量 发生改变
    func contentOffsetDidChange(_ offset: CGPoint) {
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
    
    /// 状态发生改变，更新UI
    func updateStateUI() {
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
    
    
    func updateSelfFrame() {
        
    }
    
    /// scrollView frame 发生改变
    func scrollViewFrameDidChange(_ sFrame: CGRect) {
        frame.size = CGSize(width: sFrame.width, height: EasyRefresherDefaultHeight)
    }
    
    /// scrollView 拖拽手势状态 发生改变
    func panStateDidChange(_ state: UIGestureRecognizer.State) {
        if state == .began {
            offsetYBeforeDragging = scrollView!.contentOffset.y
        } else if state == .ended {
            if self.state == .willRefreshing {
                self.beginRefreshing()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityView.center.x = frame.width * 0.5
    }
}
