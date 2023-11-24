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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        views = [UIView]()
        
        views.append(DataView().view)
        views.append(MapView().view)
        views.append(CameraView().view)
        
        for v in views {
            v.frame.size = containerView.frame.size
            containerView.addSubview(v)
        }
        
        containerView.bringSubviewToFront(views[1])
        viewSegmentedControl.selectedSegmentIndex = 1
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        containerView.bringSubviewToFront(views[sender.selectedSegmentIndex])
    }
}

