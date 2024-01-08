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
        _ = com.sendReport(coordinates: CLLocationCoordinate2D(latitude: 48.334674, longitude: 14.324331), picture: "22", dirtiness: 3, comment: "Hello")
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
