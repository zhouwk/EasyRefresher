//
//  EasyRefresherHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/12.
//

import Foundation
import UIKit

typealias EasyRefresherAction = () -> ()

class EasyRefresherHeader: UIView {
        
    
    var scrolled = CGFloat(0)
    weak var scrollView: UIScrollView?
    var insetTBeforeRefreshing: CGFloat = 0
    var offsetYBeforeDragging: CGFloat = 0
    var state = EasyRefresher.State.idle {
        didSet {
            if state == .refreshing {
                action()
            }
        }
    }
    
    let action: EasyRefresherAction
    init(_ action: @escaping EasyRefresherAction) {
        self.action = action
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 进入刷新状态
    func beginRefreshing() {}

    /// 结束刷新状态
    func endRefreshing() {}

    /// 状态发生改变，更新UI
    func updateStateUI() {}
    
    /// scrollView 偏移量 发生改变
    func contentOffsetDidChange(_ offset: CGPoint) {}

    /// scrollView frame 发生改变
    func scrollViewFrameDidChange(_ sFrame: CGRect) {
        frame.size.width = sFrame.width
    }


    override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        superviewMustBeScrollView()
        addObserves()
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
}


