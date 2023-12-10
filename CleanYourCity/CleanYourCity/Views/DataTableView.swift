//
//  DataTableView.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 09.12.23.
//

import UIKit

class DataTableView: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell

        cell.numberLabel.text = "row: \(indexPath.row)"
        
        return cell
    }
    
}
