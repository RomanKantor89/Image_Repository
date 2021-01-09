//
//  ImagePreViewViewController.swift
//  Image Repository
//
//  Created by Roman Kantor on 2021-01-07.
//



import UIKit

class ImagePreViewViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var cellIndex : Int?
    var delegate : addNewImageProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        setupGesture()
    }
    
    // adjust imageView size to new screen size when phone rotated
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
    
    // load image into view
    func loadImage(){
        imageView.image = UIImage(data: SearchService.shared.imageData[cellIndex ?? 0] as Data)
    }
    
    // save button clicked
    @IBAction func saveClicked(_ sender: Any) {
        let imageData = imageView.image!.pngData()
        showAction(imageData!)
    }
}

// extension to handle all the gesture operations
extension ImagePreViewViewController {
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
    
    // when swiped left on the image
    @objc func SwipeLeft(){
        let imgCount = SearchService.shared.imageData.count

        if cellIndex ?? 0 < imgCount-1{
            cellIndex! += 1
        }
        else{
            cellIndex! = 0
        }
    
        loadImage()
    }
    
    // when swiped right on the image
    @objc func SwipeRight(){
        if cellIndex ?? 0 > 0{
            cellIndex! -= 1
        }
        else{
            let imgCount = SearchService.shared.imageData.count
            cellIndex = imgCount-1
        }
        
        loadImage()
    }
}

// extension to handle the action sheet pop-up
extension ImagePreViewViewController{
    
    func showAction(_ image: Data){
        
        // Configuring action sheet buttons
        let cancelAction = UIAlertAction(title: "Keep Browsing", style: .default) { (alert) in
            //do nothing
        }
        
        // save the image
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
           self.delegate?.addNewImageDidFinish(image)
           // go back to previous view
           self.navigationController?.popViewController(animated: true)
        }
    
        let actionSheet = UIAlertController(title: "Confirm", message: "Save this image?", preferredStyle: .actionSheet)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
