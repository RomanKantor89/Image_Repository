//
//  ShowImageViewController.swift
//  Image Repository
//
//  Created by Eden Giterman on 2021-01-06.
//

import UIKit

protocol deleteImageProtocol{
    func deleteImageDidFinish(_ image: Image, _ index: IndexPath)
}

class ShowImageViewController: UIViewController, UINavigationControllerDelegate {
    
    var cellIndex : IndexPath?
    @IBOutlet weak var imageView: UIImageView!
    var delegate : deleteImageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the gesture setup method
        setupGesture()
        
        // load first image
        let selectedImage = CoreDataManager.shared.frc.object(at: cellIndex ?? IndexPath(index: 0))
        imageView.image = UIImage(data: (selectedImage.imgSource ?? Data()) as Data)
    }
    
    // adjust imageView size to new screen size when phone rotated
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
    
    // delete icon button clicked
    @IBAction func deleteImage(_ sender: Any) {
        let imageToDelete = CoreDataManager.shared.frc.object(at: cellIndex ?? IndexPath(index: 0))
                                                              
        showAction(imageToDelete)
    }
}

// extension to handle all the gesture operations
extension ShowImageViewController {
    // setup gesture swipe
    func setupGesture(){
        // swipe left gesture setup
        let swipeLeftGesture=UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeft))
         imageView.isUserInteractionEnabled=true
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        imageView.addGestureRecognizer(swipeLeftGesture)

        // swipe right gesture setup
         let swipeRightGesture=UISwipeGestureRecognizer(target: self, action: #selector(SwipeRight))
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
         imageView.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc func SwipeLeft(){
        let imgCount = CoreDataManager.shared.frc.fetchedObjects?.count ?? 0
        
        if cellIndex?.item ?? 0 < imgCount-1{
            cellIndex?.item += 1
        }
        else{
            cellIndex?.item = 0
        }
    
        self.imageView.image = UIImage(data:CoreDataManager.shared.frc.object(at: cellIndex ?? IndexPath(index: 0)).imgSource! as Data)
    }
       
    @objc func SwipeRight(){
        if cellIndex?.item ?? 0 > 0{
            cellIndex?.item -= 1
        }
        else{
            let imgCount = CoreDataManager.shared.frc.fetchedObjects?.count ?? 0
            cellIndex?.item = imgCount-1
        }
        
        self.imageView.image = UIImage(data:CoreDataManager.shared.frc.object(at: cellIndex ?? IndexPath(index: 0)).imgSource! as Data)

    }
}

// extension to handle the action pop-up
extension ShowImageViewController{
    
    func showAction(_ image: Image){
        
        // Configuring action sheet buttons
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            //do nothing
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
            
            self.delegate?.deleteImageDidFinish(image, self.cellIndex ?? IndexPath(index: 0))
           
           // go back to previous view
           self.navigationController?.popViewController(animated: true)
        }
    
        let actionSheet = UIAlertController(title: "Confirm", message: "Delete this image?", preferredStyle: .actionSheet)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
