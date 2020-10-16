//
//  TableViewHandler.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/16.
//

import Foundation
import UIKit



class TableViewHandler: NSObject {
    var itemCount = 0
    weak var controller: UIViewController?
    func buildIn(_ superView: UIView, frame: CGRect) -> UITableView {
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        superView.addSubview(tableView)
        return tableView
    }
}

extension TableViewHandler: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = indexPath.row % 2 == 0 ? .red : .green
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller?.dismiss(animated: true, completion: nil)
    }
}








