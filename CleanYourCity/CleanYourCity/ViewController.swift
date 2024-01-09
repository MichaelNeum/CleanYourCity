//
//  ViewController.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 24.11.23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viewSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    
    private var views: [UIView]!
    
    private var dataViewController: DataViewController!
    private var mapView: MapView!
    private var cameraView: CameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        views = [UIView]()
        
        dataViewController = DataViewController()
        mapView = MapView()
        cameraView = CameraView()
        
        cameraView.setMapView(mapView: mapView)
        
        views.append(dataViewController.view)
        views.append(mapView.view)
        views.append(cameraView.view)
        
        addChild(dataViewController)
        addChild(mapView)
        addChild(cameraView)
        
        dataViewController.didMove(toParent: self)
        mapView.didMove(toParent: self)
        cameraView.didMove(toParent: self)
        
        for v in views {
            v.frame.size = containerView.frame.size
            containerView.addSubview(v)
        }
        
        containerView.bringSubviewToFront(views[1])
        viewSegmentedControl.selectedSegmentIndex = 1
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 40
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        containerView.bringSubviewToFront(views[sender.selectedSegmentIndex])
        dataViewController.refresh()
        mapView.addStaticMarkers()
    }
}

