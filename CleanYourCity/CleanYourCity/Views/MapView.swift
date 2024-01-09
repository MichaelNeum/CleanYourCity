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
    var staticAnnotations = [MKPointAnnotation]()

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
        let data = ServerCommunication().getAllCoordinates()
        removeAllStaticMarkers()
        // Loop through locations and create annotations with names
        for report in data.reports {
            let annotation = MKPointAnnotation()
            if(report.userId == UserData.getUserId()) {
                annotation.title = String(report.reportId)
            }
            annotation.coordinate = CLLocationCoordinate2D(latitude: report.coordinates.latitude, longitude: report.coordinates.longitude)
            mapView.addAnnotation(annotation)
            staticAnnotations.append(annotation)
        }
    }
    
    func removeAllStaticMarkers() {
        mapView.removeAnnotations(staticAnnotations)
        staticAnnotations = [MKPointAnnotation]()
    }

}
