//
//  DemoTableView.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/19.
//

import UIKit

class DemoTableView: UITableView {

    
    weak var testLabel: UILabel?

    
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        
        let testLabel = UILabel(frame: .zero)
        addSubview(testLabel)
        self.testLabel = testLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(self, "deinit")
    }

    
}
