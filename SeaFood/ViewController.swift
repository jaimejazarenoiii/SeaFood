//
//  ViewController.swift
//  SeaFood
//
//  Created by Jaime Jazareno III on 17/09/2018.
//  Copyright © 2018 Jaime Jazareno III. All rights reserved.
//

import CoreML
import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = false
  }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            let ciimage = CIImage(image: userPickedImage)
            if #available(iOS 11.0, *) {
                detect(ciimage!)
            } else {
                // Fallback on earlier versions
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 11.0, *)
    func detect(_ image: CIImage) {
        let model = try? VNCoreMLModel(for: Inceptionv3().model)
        let request = VNCoreMLRequest(model: model!) { req, err in
            let results = req.results as? [VNClassificationObservation]
            self.label.text = results?.first?.identifier
            self.label.adjustsFontSizeToFitWidth = true
            self.label.isHidden = false
        }
        let handler = VNImageRequestHandler(ciImage: image)
        try! handler.perform([request])
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        label.isHidden = true
        present(imagePicker, animated: true, completion: nil)
    }
    

}

