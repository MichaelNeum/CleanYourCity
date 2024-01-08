//
//  CameraView.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 24.11.23.
//

import UIKit
import CoreLocation

class CameraView: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }
    
    @IBAction func addFoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func send(_ sender: Any) {
        let com = ServerCommunication()
        let result = com.sendReport(coordinates: CLLocationCoordinate2D(latitude: 48.334674, longitude: 14.324331), picture: "22", dirtiness: 3, comment: "Hello")
        if(result) {
            let alert = UIAlertController(title: "Report", message: "Report sent", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Report", message: "Report not sent", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showResult() {
    }
}

extension CameraView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
    }
}

extension CameraView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
