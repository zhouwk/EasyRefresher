//
//  TestView.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/10.
//

import Foundation


import UIKit

class TestView: UIView {

    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(3)
        ctx?.move(to: .zero)
        ctx?.addLine(to: CGPoint(x: 100, y: 100))
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.strokePath()
        
        
        ctx?.move(to: .zero)
        ctx?.addLine(to: CGPoint(x: 200, y: 50))
        ctx?.setStrokeColor(UIColor.green.cgColor)
        ctx?.strokePath()

    }
}
