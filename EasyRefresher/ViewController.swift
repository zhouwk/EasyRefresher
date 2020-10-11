//
//  ViewController.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/9.
//

import UIKit

class ViewController: UIViewController {
    lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame.origin.y = 50
        tableView.frame.size.height -= 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        tableView.headerRefesher = EasyRefresherActivityHeader(frame: .zero)
        
        
//        tableView.isHidden = true
        
        
        DispatchQueue.main.async {
            self.tableView.headerRefesher?.beginRefresh()
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let testView = view.subviews.first { $0 is TestView }
//        print(testView)
        
//        testView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            CATransform3DMakeRotation(0, 0, 0, 1),
            CATransform3DMakeRotation(CGFloat.pi * 2 / 3, 0, 0, 1),
            CATransform3DMakeRotation(CGFloat.pi * 4 / 3, 0, 0, 1),
            CATransform3DMakeRotation(CGFloat.pi * 2, 0, 0, 1),
        ]
        anim.duration = 2
        anim.repeatCount = Float.infinity
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        testView?.layer.add(anim, forKey: "dd")
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
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



