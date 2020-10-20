//
//  MainTableViewController.swift
//  EasyRefresher
//
//  Created by 周伟克 on 2020/10/16.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let controller = BaseDemoViewController()
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            controller.headerStyle = .activity
        case IndexPath(row: 1, section: 0):
            controller.headerStyle = .dots
        case IndexPath(row: 2, section: 0):
            controller.headerStyle = .wave
        case IndexPath(row: 3, section: 0):
            controller.headerStyle = .text
        default:
            print("-")
        }
//        controller.modalPresentationStyle = .custom
//        present(controller, animated: true, completion: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}
