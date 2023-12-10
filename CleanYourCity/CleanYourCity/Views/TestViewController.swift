//
//  TestViewController.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 09.12.23.
//

import UIKit

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        label.text = "loaded view"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataTableViewCell", for: indexPath) as! DataTableViewCell

        cell.numberLabel.text = "row: \(indexPath.row)"
        label.text = "\(indexPath.row)"
        return cell
    }


}
