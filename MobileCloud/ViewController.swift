//
//  ViewController.swift
//  MobileCloud
//
//  Created by Matt Zhu on 3/23/16.
//  Copyright © 2016 DHM. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//         imageView.image = ImageProcessor.createPosterizeImage(nil)
//        imageView.image = ImageProcessor.convertImage()
        imageView.contentMode = .ScaleAspectFit
        
//        imageView.image = ImageProcessor.createDistanceImage(nil)
        
//        imageView.image = UIImage(named: "continuity.jpg")
       // ImageProcessor.convertImage()
//        imageView.image = UIImage(named: "mirage")
        
//        let URL = "http://ec2-52-32-195-80.us-west-2.compute.amazonaws.com/morph/dilate"
//        let URL = "http://ec2-52-32-195-80.us-west-2.compute.amazonaws.com/morph/morphIn"
        let URL = "http://offloadimage.cloudapp.net/morph/dilate"

        let parameters = ["args": "testargs"]
        
        if let image = UIImage(named: "overcome.jpg"), imageData = UIImageJPEGRepresentation(image, 1.0) {
            //        if let image = imageView.image, imageData = UIImagePNGRepresentation(image) {
            Alamofire.upload(.POST, URL, multipartFormData: { (multipartFormData) -> Void in
                // add image into the same NSData body part?
                
                //                    multipartFormData.appendBodyPart(data: imageData, name: "Image")
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                multipartFormData.appendBodyPart(data: imageData, name: "morphIn", fileName: "morphIn.jpg", mimeType: "application/octet-stream")
                })
            { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _ ):
                    upload.responseJSON { response in
                        
                        let latency = response.timeline.latency
                        
                        let image = UIImage(data: response.data! as NSData)
                        self.imageView.image = image
                        guard let JSON = response.result.value else {
                            print("Error: did not receive data")
                            return
                        }
                        
                        guard response.result.error == nil else {
                            print("error calling GET on /posts/1")
                            print(response.result.error)
                            return
                        }
                        
                                    print(response.request)
                                    print(response.response)
                                    print(response.data)
                        print("JSON: \(JSON)")
                        if let dict = JSON as? [String: AnyObject] {
                            // create Talk object corresponding to Talk Entity

                            
                            
                        }
                        
                    }
                case .Failure(let encodingError):
                    print("Failure")
                    print(encodingError)
                }
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

