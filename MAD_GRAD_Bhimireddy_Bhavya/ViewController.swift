//
//  ViewController.swift
//  MAD_GRAD_Bhimireddy_Bhavya
//
//  Created by Bhavya Bhimireddy on 4/25/22.
//

import UIKit
import CoreML
import Vision
import ImageIO
import VideoToolbox

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let mobil = MobileNet().model
    let boxcaar = MyImageClassifierBoxcar().model
    
    
    
    
    
    
    var chosenImage = CIImage()
    //let model = Boxcar_Classification()
    
    @IBOutlet weak var imageview: UIImageView!
   
    @IBOutlet weak var resultlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func albume(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
        
        
    func recognizeImage(image: CIImage) {
            
            // 1) Request
            // 2) Handler
            
            resultlabel.text = "Finding ..."
            
            if let model = try? VNCoreMLModel(for: boxcaar) {
                let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                    
                    if let results = vnrequest.results as? [VNClassificationObservation] {
                        if results.count > 0 {
                            
                            let topResult = results.first
                            
                            DispatchQueue.main.async {
                                //
                                let confidenceLevel = (topResult?.confidence ?? 0) * 100
                                
                                let rounded = Int (confidenceLevel * 100) / 100
                                
                                self.resultlabel.text = "\(rounded)% it's \(topResult!.identifier)"
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                let handler = VNImageRequestHandler(ciImage: image)
                      DispatchQueue.global(qos: .userInteractive).async {
                        do {
                            request.usesCPUOnly = true
                        try handler.perform([request])
                        } catch {
                            print("error")
                        }
                }
                
                
            }
            
          
            
        }
   
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageview.image = info[.originalImage] as? UIImage
                self.dismiss(animated: true, completion: nil)
                
                if let ciImage = CIImage(image: imageview.image!) {
                    chosenImage = ciImage
                }
                
                recognizeImage(image: chosenImage)
                
    }
    
    

}
