//
//  EasyRefresherWaveHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/16.
//

import UIKit

class EasyRefresherWaveHeader: EasyRefresherHeader {

    
    
    
    var backWave: WaveView!
    var frontWave: WaveView!
    let selfHeight = CGFloat(20)
    
    override init(_ action: @escaping EasyRefresherAction) {
        super.init(action)
        setupWaves()
    }
    
    func setupWaves() {
        backWave = WaveView()
        backWave.A = -4
        backWave.k = 0.5
        backWave.speed = 10
        backWave.w = 1
        backWave.color = UIColor.green.withAlphaComponent(0.1).cgColor
        addSubview(backWave)
        
        
        frontWave = WaveView()
        frontWave.A = -6
        frontWave.k = 0.5
        frontWave.φ = 90
        frontWave.speed = 10
        frontWave.w = 1
        frontWave.color = UIColor.green.withAlphaComponent(0.1).cgColor
        addSubview(frontWave)

        
        backWave.backgroundColor = .clear
        frontWave.backgroundColor = .clear
    }
    
    
    override func beginRefreshing() {
        if state == .refreshing {
            return
        }
        state = .refreshing
        UIView.animate(withDuration: 0.25) {
            self.scrollView!.contentInset.top = self.insetTBeforeRefreshing + self.selfHeight
            self.updateStateUI()
        }
    }
    
    
    override func endRefreshing() {
        if state != .refreshing {
            return
        }
        state = .idle
        UIView.animate(withDuration: 0.25) {
            self.scrollView!.contentInset.top = self.insetTBeforeRefreshing
            self.updateStateUI()
        }
    }
    
    
    override func contentOffsetDidChange(_ offset: CGPoint) {
        if state == .refreshing {
            return
        }
        var top = scrollView!.contentInset.top
        if #available(iOS 11.0, *) {
            top += scrollView!.safeAreaInsets.top
        }
        insetTBeforeRefreshing = scrollView!.contentInset.top
        scrolled = scrollView!.contentOffset.y + top
        if -scrolled >= 0 {
            if -scrolled >= selfHeight {
                state = .willRefreshing
            } else {
                state = .pulling
            }
        } else {
            state = .idle
        }
        updateStateUI()
    }
    
    override func updateStateUI() {
        if state == .refreshing || state == .willRefreshing {
            backWave.beginWaving()
            frontWave.beginWaving()
        } else {
            backWave.endWaving()
            frontWave.endWaving()
            if state == .idle {
                frame.origin.y = -selfHeight
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame.size.height = selfHeight
        frame.origin.y = -selfHeight
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backWave.frame = bounds
        frontWave.frame = bounds
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
