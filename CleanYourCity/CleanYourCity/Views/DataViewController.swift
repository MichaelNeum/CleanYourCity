//
//  DataViewController.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 10.12.23.
//

import UIKit

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var data: [ReportData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ReportData.sampleData
        
        tableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
        
        cell.numberLabel.text = data[indexPath.row].id
        cell.dateLabel.text = "\(data[indexPath.row].date)"
        cell.statusLabel.text = data[indexPath.row].status
        
        return cell
    }

}
