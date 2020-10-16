//
//  EasyRefresherTextHeader.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/15.
//

import UIKit

enum EasyRefresherRenderMode {
    case normal
    case highlight
}
class EasyRefresherTextHeader: UIView {
    
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
