//
//  ViewController.swift
//  TabBar2.0
//
//  Created by Kaung Thu Khant on 11/6/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

