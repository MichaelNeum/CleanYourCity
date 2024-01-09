//
//  MapView.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 24.11.23.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIButton!
    let locationManager = CLLocationManager()
    var userAnnotation: MKPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Request location authorization
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.showsUserLocation = false // Hide default user location annotation
        
        // Set action for the button
        centerButton.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
        addStaticMarkers()
    }
    
    @objc func centerMap() {
            if let userLocation = userAnnotation?.coordinate {
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
        }
    }
    
    func getUserLocation() -> CLLocationCoordinate2D {
        return userAnnotation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    // MARK: - CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            if userAnnotation == nil {
                // If the annotation doesn't exist, create and add it
                let annotation = MKPointAnnotation()
                annotation.coordinate = userLocation
                annotation.title = "Your Location"
                mapView.addAnnotation(annotation)
                userAnnotation = annotation

                // Set the initial region and zoom level
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            } else {
                // If the annotation exists, update its position
                userAnnotation?.coordinate = userLocation
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func addStaticMarkers() {
            // Define coordinates for static locations in Linz, Austria
                let locations = [
                    ("Report - Y", CLLocationCoordinate2D(latitude: 48.337574, longitude: 14.318090)),
                    ("Report - X", CLLocationCoordinate2D(latitude: 48.336597, longitude: 14.318124)),
                    ("Report - Z", CLLocationCoordinate2D(latitude: 48.334674, longitude: 14.324331))
                    // Add more locations with names and coordinates in Linz as needed
                ]
                
                // Loop through locations and create annotations with names
                for location in locations {
                    let annotation = MKPointAnnotation()
                    annotation.title = location.0 // Set the name as the title
                    annotation.coordinate = location.1
                    mapView.addAnnotation(annotation)
                }
    }
    
    

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
