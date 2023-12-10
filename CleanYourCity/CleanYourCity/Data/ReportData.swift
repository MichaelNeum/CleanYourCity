//
//  ReportData.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 24.11.23.
//

import Foundation

struct ReportData {
    var id: String
    var date: Date
    var status: String
}

extension ReportData {
    static var sampleData = [
        ReportData(id: "Report 1", date: Date().addingTimeInterval(800.0), status: "done"),
        ReportData(id: "Report 2", date: Date().addingTimeInterval(1200.0), status: "recieved"),
        ReportData(id: "Report 3", date: Date().addingTimeInterval(1520.0), status: "in work")
    ]
}

