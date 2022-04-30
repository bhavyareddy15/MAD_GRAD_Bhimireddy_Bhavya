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
        
        
        
        
    }
//    @IBAction func camera(_ sender: Any) {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//        imagePickerController.sourceType = .camera
//        present(imagePickerController, animated: true, completion: nil)
//
//
//
//    }
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
    
   // func predictUsingCoreML(image: UIImage) {
    //  if let pixelBuffer = image.pixelBuffer(width: 224, height: 224),
      //   let prediction = try? model.prediction(image: pixelBuffer) {
       // let top5 = top(5, prediction.prob)
      //  show(results: top5)

        // This is just to test that the CVPixelBuffer conversion works OK.
        // It should have resized the image to a square 224x224 pixels.
      //  var imoog: CGImage?
      //  VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &imoog)
        //imageview.image = UIImage(cgImage: imoog!)
   //   }
//    }

    /*
     This uses the Vision framework to drive Core ML.
     Note that this actually gives a slightly different prediction. This must
     be related to how the UIImage gets converted.
     */
  //  func predictUsingVision(image: UIImage) {
  //    guard let visionModel = try? VNCoreMLModel(for: model.model) else {
  //      fatalError("Someone did a baddie")
   //   }

  //    let request = VNCoreMLRequest(model: visionModel) { request, error in
  //      if let observations = request.results as? [VNClassificationObservation] {

          // The observations appear to be sorted by confidence already, so we
          // take the top 5 and map them to an array of (String, Double) tuples.
        //  let top5 = observations.prefix(through: 4)
                              //   .map { ($0.identifier, Double($0.confidence)) }
            
 //           resultlabel.text = request.results.
         // self.show(results: top5)
   //       }
     // }

   //   request.imageCropAndScaleOption = .centerCrop

  //    let handler = VNImageRequestHandler(cgImage: image.cgImage!)
    //  try? handler.perform([request])
 //   }

    // MARK: - UI stuff

 //   typealias Prediction = (String, Double)

 //   func show(results: [Prediction]) {
  //    var s: [String] = []
  //    for (i, pred) in results.enumerated() {
  //      s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
  //    }
  //    resultlabel.text = s.joined(separator: "\n\n")
   //

  //  func top(_ k: Int, _ prob: [String: Double]) -> [Prediction] {
  //    precondition(k <= prob.count)

  //    return Array(prob.map { x in (x.key, x.value) }
  //                     .sorted(by: { a, b -> Bool in a.1 > b.1 })
  //                     .prefix(through: k - 1))
  //  }
    
    
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
