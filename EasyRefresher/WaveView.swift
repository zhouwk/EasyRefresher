//
//  WaveView.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/15.
//

import UIKit

class WaveView: UIView {
    
    
    
//     y=Asin(ωx+φ)+k
    
    var color = UIColor.clear.cgColor
    var A = CGFloat(-2)
    var w = CGFloat(-2)
    var φ = CGFloat(2)
    var k = CGFloat(0) {
        didSet {
            if k < 0 {
                k = 0
            } else if k > 1 {
                k = 1
            }
        }
    }
    
    var speed = CGFloat(2)
    
    

    private lazy var timer: CADisplayLink = {
        let timer = CADisplayLink(target: self, selector: #selector(proceed))
        timer.add(to: .main, forMode: .common)
        return timer
    }()
    
    
    override func draw(_ rect: CGRect) {
        let degreeStep = w * 360 / frame.width
        let ctx = UIGraphicsGetCurrentContext()
        var pointY: CGFloat
        var point: CGPoint
        for x in 0 ... Int(frame.size.width) {
            pointY = A * sin(degreeToRadian(CGFloat(x) * degreeStep) + degreeToRadian(φ)) + frame.height * (1 - k)
            point = CGPoint(x: CGFloat(x), y: pointY)
            if x == 0{
                ctx?.move(to: point)
            } else {
                ctx?.addLine(to: point)
            }
        }
        ctx?.addLine(to: CGPoint(x: rect.width, y: rect.height))
        ctx?.addLine(to: CGPoint(x: 0, y: rect.height))
        ctx?.closePath()
        ctx?.setFillColor(color)
        ctx?.fillPath()
    }
    
    
    
    func beginWaving() {
        timer.isPaused = false
    }
    
    func endWaving() {
        timer.isPaused = true
    }
    
    
    @objc func proceed() {
        φ += speed
        setNeedsDisplay()
    }
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
}
