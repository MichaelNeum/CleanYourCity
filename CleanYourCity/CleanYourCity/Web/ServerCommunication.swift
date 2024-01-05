import Foundation
import CoreLocation

class ServerCommunication {
    private let reportUrl = "localhost:3000/send/report"
    func sendReport(coordinates: CLLocationCoordinate2D, picture: String, dirtiness: Int, comment: String) -> Bool{
        guard let url = URL(string: reportUrl) else {
            return false
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let cords = Coordinates(longitude: coordinates.longitude, latitude: coordinates.latitude)
        let report = Report(userId: "", reportId: 0, coordinates: cords, picture: picture, dirtiess: dirtiness, comment: comment, status: "")
        request.httpBody = try? JSONEncoder().encode(report)
        var success = false
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Report.self, from: data)
                if(response.status == "received") {
                    success = true
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        return success
    }
}

