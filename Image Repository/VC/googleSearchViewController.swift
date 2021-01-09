//
//  googleSearchViewController.swift
//  Image Repository
//
//  Created by Roman Kantor on 2021-01-07.
//

import UIKit

class googleSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchStart = 0
    var currentSearch = ""
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clearButton: UIButton!
    var delegate : addNewImageProtocol?
    @IBOutlet weak var loadMoreButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearButton.layer.cornerRadius = 5
    }
    
    // number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchService.shared.imageData.count
    }
    
    // populate the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "googleCell", for: indexPath) as! imageCell
    
        cell.imageView.image = UIImage(data: SearchService.shared.imageData[indexPath.item] as Data)
        
        return cell
    }
    
    // load more images of the same search
    @IBAction func loadMoreImages(_ sender: Any) {
        searchStart += 10
        currentSearch = searchBar.text ?? ""
        searchBarSearchButtonClicked(self.searchBar)
    }
    
    // clear everything
    @IBAction func clearClicked(_ sender: Any) {
        searchStart = 0
        SearchService.shared.imageData = []
        searchBar.text = ""
        self.collectionView.reloadData()
        self.loadMoreButton.isEnabled = false
    }
    
    // prepare before moving to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "showGoogleImage"{
            let ImagePreViewVC = segue.destination as! ImagePreViewViewController
            let cell = sender as! UICollectionViewCell
            let index = self.collectionView!.indexPath(for: cell)?.item ?? 0

            ImagePreViewVC.cellIndex = index
            ImagePreViewVC.delegate = delegate
        }
    }
}


// extension for the  search bar
extension googleSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // check if its still same search or a new one
        if currentSearch != searchBar.text {
            SearchService.shared.imageData = []
            searchStart = 0
        }
        
        // prepare for calling google api and call it
        if let searchText = searchBar.text{
            searchBar.endEditing(true)
            // make spaces acceptable in the search
            let imporvedSearch = searchText.replacingOccurrences(of: " ", with: "%20")
            
            // call the loading indicator to let user know the App is working on getting results
            loadingIndicator()
            // call the google API
            SearchService.shared.fetchGoogleResults(imporvedSearch, searchStart) { () in
                 DispatchQueue.main.async {
                  // reload the table
                  self.collectionView.reloadData()
                  self.stopLoadingIndicator()
                  self.loadMoreButton.isEnabled = true
                 }
           }
        }
    }
}

// extension for loading indicator
extension googleSearchViewController{
    
    func loadingIndicator(){
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func stopLoadingIndicator(){
        dismiss(animated: false, completion: nil)
    }
}
