//
//  Report.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 05.01.24.
//

struct ReportList: Codable {
    let reports: [Report]
}

struct Report: Codable {
    let userId: String
    let reportId: Int
    let coordinates: Coordinates
    let picture: String
    let dirtiess: Int
    let comment: String
    let status: String
}

struct Coordinates: Codable {
    let longitude: Double
    let latitude: Double
}
