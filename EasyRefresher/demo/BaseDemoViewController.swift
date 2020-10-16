//
//  BaseDemoViewController.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/16.
//

import UIKit


enum RefreshStyle {
    case none, activity, dots, wave
}


class BaseDemoViewController: UIViewController {

    lazy var handler = TableViewHandler()
    lazy var tableView = handler.buildIn(self.view, frame: self.view.bounds)
    
    
    var headerStyle = RefreshStyle.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handler.controller = self
        initRefresherHeader()
        
        tableView.headerRefesher?.beginRefreshing()
    }
    
    
    /// header 刷新
    func initRefresherHeader() {
        if headerStyle == .activity {
            tableView.headerRefesher = EasyRefresherActivityHeader(doSomeWork)
        } else if headerStyle == .dots {
            tableView.headerRefesher = EasyRefresherDottedHeader(doSomeWork)
        } else if headerStyle == .wave {
            tableView.headerRefesher = EasyRefresherWaveHeader(doSomeWork)
        }
    }


    func doSomeWork() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.headerRefesher?.endRefreshing()
            self.handler.itemCount += 1
            self.tableView.reloadData()
        }
    }
}
