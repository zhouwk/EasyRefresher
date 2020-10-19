//
//  ViewController.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/9.
//

import UIKit


class ViewController: UIViewController {
    lazy var tableView = UITableView(frame: view.bounds, style: .plain)
     
    var cellCount = 0

    
    
    var timer: CADisplayLink!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.headerRefesher = EasyRefresherWaveHeader({
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.headerRefesher?.endRefreshing()
                self.cellCount += 1
                self.tableView.reloadData()
            }
        })
        tableView.headerRefesher?.beginRefreshing()
        tableView.tableFooterView = UIView()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount
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
    }
}



