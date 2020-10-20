//
//  EasyRefresherTextHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/15.
//

import UIKit


class EasyRefresherTextHeader: EasyRefresherHeader {
 
    
    private lazy var textStateMap: [EasyRefresher.State: String] = {
        var map = [EasyRefresher.State: String]()
        map[.idle] = "下拉加载更多"
        map[.pulling] = map[.idle]
        map[.willRefreshing] = "释放立即刷新"
        map[.refreshing] = "加载中..."
        return map
    }()
    

    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(textLabel)
        return textLabel
    }()
    
    let selfH = CGFloat(45)

    
    
    override func beginRefreshing() {
        if state == .refreshing {
            return
        }
        state = .refreshing
        layoutTextLabel()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.scrollView!.contentInset.top += self.selfH
            }
        }
    }
    
    
    override func endRefreshing() {
        if state != .refreshing {
            return
        }
        state = .idle
        layoutTextLabel()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.scrollView!.contentInset.top -= self.selfH
            }
        }
    }
    
    
    
    override func contentOffsetDidChange(_ offset: CGPoint) {
        super.contentOffsetDidChange(offset)
        if state == .refreshing {
            return
        }
        var insetT = scrollView!.contentInset.top
        if #available(iOS 11.0, *) {
            insetT += scrollView!.safeAreaInsets.top
        }
        scrolled = offset.y + insetT
        if -scrolled >= selfH {
            state = .willRefreshing
        } else {
            state = .idle
        }
        updateStateUI()
    }
    
    
    override func updateStateUI() {
        super.updateStateUI()
        layoutTextLabel()
    }
    
    func layoutTextLabel() {
        textLabel.text = textStateMap[state]
        textLabel.sizeToFit()
        textLabel.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame.size.height = -selfH
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTextLabel()
    }
    
    
}



enum EasyRefresherRenderMode {
    case normal
    case highlight
}
class EasyRefresherTextHeader2: UIView {
    
    var text = Bundle.main.infoDictionary!["CFBundleName"] as! String {
        didSet {
            positionTextLabels()
        }
    }
    var textFont = UIFont.systemFont(ofSize: 25) {
        didSet {
            positionTextLabels()
        }
    }

    var textIdleColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) {
        didSet {
            backLabel.textColor = textIdleColor
        }
    }
    
    var textWavingColor = UIColor.orange {
        didSet {
            frontLabel.textColor = textWavingColor
        }
    }
    
    
    let verticalPadding = CGFloat(30)
    
    
    let backLabel = UILabel()
    let frontLabel = UILabel()
    let waveView = WaveView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backLabel.textColor = textIdleColor
        addSubview(backLabel)
        
        frontLabel.textColor = textWavingColor
        addSubview(frontLabel)
        
        waveView.backgroundColor = .clear
        frontLabel.layer.mask = waveView.layer
        
        self.frame.size.height = backLabel.frame.height + verticalPadding * 2
    }
    
    
    
    
    /// 居中文本
    private func positionTextLabels() {
        for label in [backLabel, frontLabel] {
            label.font = textFont
            label.text = text
            label.sizeToFit()
            label.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        }
        waveView.frame = CGRect(origin: .zero, size: frontLabel.frame.size)
        waveView.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        positionTextLabels()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
