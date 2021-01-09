//
//  UploadImageViewController.swift
//  Image Repository
//
//  Created by Eden Giterman on 2021-01-06.
//

import UIKit

protocol addNewImageProtocol{
    func addNewImageDidFinish(_ image: Data)
}

class UploadImageViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    var delegate : addNewImageProtocol?
    @IBOutlet weak var errorLabel: UILabel!
    var tempImage : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let fixedImageData = imagePreview.image!.fixOrientation()

        let imageData = fixedImageData!.pngData()
        showAction(imageData!)
    }
    
}

// image extension to make
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
                self.delegate?.addNewImageDidFinish(image)
               
               // go back to previous view
               self.navigationController?.popViewController(animated: true)
            }
            else{
                self.errorLabel.text = "Please pick an image first."
                self.errorLabel.alpha = 1
            }
           
        }
    
        let actionSheet = UIAlertController(title: "Confirm", message: "Save this image?", preferredStyle: .actionSheet)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
