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
    
    
    
    
    var timer: EasyTimer!
    
    
    var arr = [1, 2, 3, 4]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.frame.origin.y = 50
        tableView.frame.size.height -= 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        tableView.headerRefesher = EasyRefresherDottedHeader({
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.headerRefesher?.endRefreshing()
                self.cellCount += 1
                self.tableView.reloadData()
            }
        })
//        tableView.headerRefesher?.beginRefreshing()
//        tableView.isHidden = true
        
        
        
        tableView.headerRefesher?.beginRefreshing()
        
        
        tableView.headerRefesher?.backgroundColor = .orange


        


    }
    
    
    var value = CGFloat(0)
    var aTrend = false
    
 
    
    
    
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}



