//
//  ImageRepository.swift
//  Image Repository
//
//  Created by Eden Giterman on 2021-01-06.
//

import UIKit

class ImageRepository: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, addNewImageProtocol, deleteImageProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchOnlineButton: UIButton!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    var tempImage = UIImageView()
    @IBOutlet weak var previewUploadPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
        
//        uploadPhotoButton.layer.cornerRadius = 5
//        searchOnlineButton.layer.cornerRadius = 5
//        uploadPhotoButton.backgroundColor = UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 1)
    }
    
    // delete image protocol implementation
    func deleteImageDidFinish(_ image: Image, _ index : IndexPath) {
        CoreDataManager.shared.deleteImage(image)
        collectionView.deleteItems(at: [index])
        getImages()
    }
    
    // implement add new image protocol
    func addNewImageDidFinish(_ image: Data) {
        let allImages = CoreDataManager.shared.frc.fetchedObjects ?? [Image]()
        CoreDataManager.shared.addImage(image, allImages)
        
        // refresh the collection
        getImages()
    }
    
    // get all the images from core data
    func getImages(){
        do{
            try CoreDataManager.shared.frc.performFetch()
        }
        catch{
            print("Frc fetching error")
        }
        self.collectionView.reloadData()
    }
    
    
    
    // number of collection cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if CoreDataManager.shared.frc.sections?.count == 0 {
            return 0
        }
        else{
            return CoreDataManager.shared.frc.sections?[section].numberOfObjects ?? 0
        }
    }
    
    // populate the collection cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCell
    
        
        cell.imageView.image = UIImage(data:CoreDataManager.shared.frc.object(at: indexPath).imgSource! as Data)
        
        return cell
    }
    
    
    
    // prepare before moving to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewImage" {
            let previewImageVC = segue.destination as! UploadImageViewController
            previewImageVC.delegate = self
            previewImageVC.tempImage = self.tempImage
        }
        else if segue.identifier == "showImage"{
            let showImageVC = segue.destination as! ShowImageViewController
            
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell) ?? IndexPath(index: 0)

            showImageVC.cellIndex = indexPath
            showImageVC.delegate = self
        }
        else if segue.identifier == "searchOnline" {
            SearchService.shared.imageData = []
            let onlinePreViewVC = segue.destination as! googleSearchViewController
            
            onlinePreViewVC.delegate = self
        }
    }

}

extension ImageRepository{
    // take/upload photo clicked
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let ipc = UIImagePickerController()
        
        // open camera or gallery
        if sender.tag == 0{
            // use camera to take a photo
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                ipc.sourceType = .camera
            }
        }
        else{
            if UIImagePickerController.isSourceTypeAvailable(          .photoLibrary){
                ipc.sourceType = .photoLibrary
            }
        }
        
        ipc.delegate = self
        ipc.allowsEditing = false
        present(ipc, animated: true, completion: nil)
    }
    
    // check if there is image data in selected image and assign to UIImage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){

           if let image = info[.originalImage] as? UIImage {
            tempImage.image = image
           }
           dismiss(animated: true, completion: nil)
           previewUploadPhotoButton.sendActions(for: .touchUpInside)

    }

    // close photo picker if cancel clicked
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
         dismiss(animated: true, completion: nil)
     }
}



// custom image collection view cell
class imageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
