//
//  UIScrollView+Refresher.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/9.
//

import Foundation
import UIKit


var EASY_HEADER_REFRESH_KEY = 0
var EASY_FOOTER_REFRESH_KEY = 1


extension UIScrollView {
    var headerRefesher: EasyRefresherHeader? {
        set {
            setHeaderRefreher(newValue)
        }
        get {
            getHeaderRefresher()
        }
    }
    
    
    private func setHeaderRefreher(_ newValue: EasyRefresherHeader?) {
        headerRefesher?.removeFromSuperview()
        if let newValue = newValue {
            insertSubview(newValue, at: 0)
        }
        objc_setAssociatedObject(self,
                                 &EASY_HEADER_REFRESH_KEY,
                                 newValue,
                                 .OBJC_ASSOCIATION_ASSIGN)
    }
    
    private func getHeaderRefresher() -> EasyRefresherHeader? {
        objc_getAssociatedObject(self,
                                 &EASY_HEADER_REFRESH_KEY) as? EasyRefresherHeader

    }
}
