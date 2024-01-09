import Foundation
import CoreLocation
import UIKit

class ServerCommunication {
    private let reportUrl = "http://localhost:3000/send/report"
    private let coordinatesUrl = "http://localhost:3000/get/allcoordinates"
    private let myReportsUrl = "http://localhost:3000/get/myreports"
    
    private let userId = "219714422"
    
    func sendReport(coordinates: CLLocationCoordinate2D, picture: String, dirtiness: Int, comment: String) -> Bool {
        guard let url = URL(string: reportUrl) else {
            return false
        }
        
        var request = URLRequest(url: url)
        let sem = DispatchSemaphore.init(value: 0)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let date = "\(Date())"
        let cords = Coordinates(longitude: coordinates.longitude, latitude: coordinates.latitude)
        let report = Report(userId: UserData.getUserId(), reportId: 0, coordinates: cords, picture: picture, dirtiness: dirtiness, comment: comment, status: "", date: date)
        request.httpBody = try? JSONEncoder().encode(report)
        var success = false
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            defer { sem.signal() }
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Report.self, from: data)
                if(response.status == "received") {
                    success = true
                }
                if(UserData.getUserId() != response.userId) {
                    UserData.setUserId(id: response.userId)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        sem.wait()
        return success
    }
    
    func getAllCoordinates() -> ReportList {
        var result: ReportList? = nil
        guard let url = URL(string: coordinatesUrl) else {
            return result!
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let report = Report(userId: "", reportId: 0, coordinates: Coordinates(longitude: 0, latitude: 0), picture: "", dirtiness: 0, comment: "", status: "", date: "")
        request.httpBody = try? JSONEncoder().encode(report)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                result = try JSONDecoder().decode(ReportList.self, from: data)
            } catch {
                print(error)
            }
        }
        
        task.resume()
        return result!
    }
    
    func getMyReports() -> ReportList {
        var result: ReportList? = nil
        guard let url = URL(string: myReportsUrl) else {
            return result!
        }
        
        var request = URLRequest(url: url)
        let sem = DispatchSemaphore.init(value: 0)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let report = Report(userId: UserData.getUserId(), reportId: 0, coordinates: Coordinates(longitude: 0, latitude: 0), picture: "", dirtiness: 0, comment: "", status: "", date: "")
        request.httpBody = try? JSONEncoder().encode(report)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            defer { sem.signal() }
            guard let data = data, error == nil else {
                return
            }
    
            do {
                result = try JSONDecoder().decode(ReportList.self, from: data)
            } catch {
                print(error)
            }
        }
        task.resume()
        sem.wait()
        return result!
    }
}

