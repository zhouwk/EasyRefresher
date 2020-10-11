//
//  EasyActivityIndicatorView.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/9.
//

import UIKit


let degreeToRadian: (CGFloat) -> CGFloat = { $0 * CGFloat.pi / 180 }

class EasyActivityIndicatorView: UIView {

    var inRadius: CGFloat = 7
    var outRadius: CGFloat = 0
    let totalLineCount = 12
    let lineWidth: CGFloat = 2
    var firstLineColorAlpha: CGFloat = 0
    lazy var degreePerLine = 360.0 / CGFloat(totalLineCount)
    lazy var colorAlphaPerLine = 1 / CGFloat(totalLineCount)
    private(set) var isAnimating = false
    var animCounter = 0
    var eTimer: EasyTimer?
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(lineWidth)
        ctx?.setLineCap(.round)
        let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        var degree: CGFloat
        var lineColorAlpha: CGFloat
        for line in 0 ..< totalLineCount {
            degree = CGFloat(line) * degreePerLine
            ctx?.move(to: CGPoint(x: center.x + sin(degreeToRadian(degree)) * inRadius,
                                  y: center.y - cos(degreeToRadian(degree)) * inRadius))
            ctx?.addLine(to: CGPoint(x: center.x + sin(degreeToRadian(degree)) * outRadius,
                                     y: center.y - cos(degreeToRadian(degree)) * outRadius))
            if (isAnimating) {
                lineColorAlpha =  1 - CGFloat(line) * colorAlphaPerLine + CGFloat(animCounter) * colorAlphaPerLine
                if lineColorAlpha > 1 {
                    lineColorAlpha -= 1
                }
                ctx?.setStrokeColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: lineColorAlpha).cgColor)
                ctx?.strokePath()
            }
        }
        if !isAnimating {
            ctx?.setStrokeColor(UIColor.darkGray.withAlphaComponent(firstLineColorAlpha).cgColor)
            ctx?.strokePath()
        }
    }

    
    func drawUsingScale(_ scale: CGFloat) {
        frame.size.width = scale * EasyActivityDefaultHeight
        frame.size.height = scale * EasyActivityDefaultHeight
        inRadius = 7 * scale
        outRadius = frame.width * 0.5 - 3
        if scale == 1 {
            if isAnimating {
                return
            }
            firstLineColorAlpha = 1
            startAnimate()
        } else {
            firstLineColorAlpha = scale * 0.5
            stopAniamte()
        }
        setNeedsDisplay()
    }
    
    func startAnimate() {
        if eTimer == nil {
            eTimer = EasyTimer.set(interval: 0.05, task: { [weak self] in
                guard let ws = self else {
                    return
                }
                ws.animCounter = (ws.animCounter + 1) % ws.totalLineCount
//                ws.firstLineColorAlpha -= ws.colorAlphaPerLine
//                if ws.firstLineColorAlpha <= 0 {
//                    ws.firstLineColorAlpha = 1
//                }
                ws.setNeedsDisplay()
            })
        } else {
            eTimer?.resume()
        }
        isAnimating = true
    }
    
    func stopAniamte() {
        eTimer?.pause()
        isAnimating = false
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
