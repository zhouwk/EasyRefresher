//
//  BaseDemoViewController.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/16.
//

import UIKit


enum RefreshStyle {
    case none, activity, dots, wave, text
}


class BaseDemoViewController: UIViewController {

    lazy var handler = TableViewHandler()
    lazy var tableView = handler.buildIn(self.view, frame: self.view.bounds)
    
    
    
    weak var label: UILabel?
    
    var headerStyle = RefreshStyle.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handler.controller = self
        initRefresherHeader()
        tableView.headerRefesher?.beginRefreshing()
        
        
        
        let label = UILabel()
        view.addSubview(label)
        self.label = label
    }
    
    
    /// header 刷新
    func initRefresherHeader() {
        if headerStyle == .activity {
            tableView.headerRefesher = EasyRefresherActivityHeader({ [weak self] in
                self?.doSomeWork()
            })
        } else if headerStyle == .dots {
            tableView.headerRefesher = EasyRefresherDottedHeader({ [weak self] in
                self?.doSomeWork()
            })
        } else if headerStyle == .wave {
            tableView.headerRefesher = EasyRefresherWaveHeader({ [weak self] in
                self?.doSomeWork()
            })
        } else if headerStyle == .text {
            tableView.headerRefesher = EasyRefresherTextHeader({ [weak self] in
                self?.doSomeWork()
            })
        }
    }


    func doSomeWork() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.tableView.headerRefesher?.endRefreshing()
            self?.handler.itemCount += 1
            self?.tableView.reloadData()
        }
    }
    
    
    deinit {
        print(self, "deinit")
    }

}
