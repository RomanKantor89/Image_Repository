//
//  UploadImageViewController.swift
//  Image Repository
//
//  Created by Roman Kantor on 2021-01-06.
//

import UIKit

// protocol to add new image to the collection
protocol addNewImageProtocol{
    func addNewImageDidFinish(_ image: Data)
}

class UploadImageViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    var delegate : addNewImageProtocol?
    var tempImage : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize image preview
        imagePreview.image = tempImage?.image ?? UIImage()
    }
    
    // adjust imageView size to new screen size when phone rotated
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            let screenSize: CGRect = UIScreen.main.bounds
        imagePreview.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }

    // save the chosen photo to Core Data
    @IBAction func saveClicked(_ sender: Any) {
        // fix the image orentation when taken with camera
        let fixedImageData = imagePreview.image!.fixOrientation()
        let imageData = fixedImageData!.pngData()
        showAction(imageData!)
    }
}

// image extension to fix image orientation
extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}

// action sheet extension to confirm the save
extension UploadImageViewController{
    
    func showAction(_ image: Data){
        
        // Configuring action sheet buttons
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            //do nothing
        }
        
        // save the image
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            
            // check if image was selected
            if image != UIImage.init(named: "imagePreview")?.pngData(){
                // call the protocol method
                self.delegate?.addNewImageDidFinish(image)
               // go back to previous view
               self.navigationController?.popViewController(animated: true)
            }
            else{
                print("Something went wrong with saving the image")
            }
           
        }
    
        let actionSheet = UIAlertController(title: "Confirm", message: "Save this image?", preferredStyle: .actionSheet)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
