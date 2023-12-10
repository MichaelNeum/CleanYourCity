//
//  DataTableViewController.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 10.12.23.
//

import UIKit

class DataTableViewController: UITableViewController {
    
    
        
    @IBOutlet var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        myTableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        myTableView.dataSource = self
        myTableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell

        cell.numberLabel.text = "number: \(indexPath.row)"

        return cell
    }
}
