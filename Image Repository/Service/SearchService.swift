//
//  SearchService.swift
//  Image Repository
//
//  Created by Roman Kantor on 2021-01-07.
//

import Foundation

class SearchService {
    static var shared = SearchService()
    // array of image data to temporarily store results of downloaded images from the web
    var imageData = [Data]()
    // private information stored in enviromental variables
    var API_KEY = ""
    var CX = ""
    
    // API to fetch google image links for a specific word or phrase
    func fetchGoogleResults(_ question :String, _ start: Int, handler : @escaping ()->Void) {
        
        // get enviromental variables
        if let val = ProcessInfo.processInfo.environment["Google_API_Key"] {
            API_KEY = val
        }
        if let val = ProcessInfo.processInfo.environment["Google_CX"] {
            CX = val
        }
        
        guard let myUrl = URL(string: "https://www.googleapis.com/customsearch/v1?key=\(API_KEY)&cx=\(CX)&searchType=image&start=\(start)&q=\(question)") else {return}
        URLSession.shared.dataTask(with: myUrl) { (data, request, error) in
         
            if let _ = error {return}
            guard let httpResponse = request as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else {
                    // Show the URL and response status code in the debug console
                    if let httpResponse = request as? HTTPURLResponse {
                        print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                    }
                    return
                }
                                               
              if let myData = data{
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: myData, options: []) as! NSDictionary
                    
                    // access jsonObject
                    if let items = jsonObject["items"] as? Array<NSDictionary>{
                        // loop through all the results and download the images
                        for item in items{
                            print(item["link"] ?? "")
                            let res = self.getImage(item["link"] as! String)
                            if res != nil{
                                self.imageData.append(res ?? Data())
                            }
                        }
                    }
                    // completion handler
                    handler()
                }catch {
                    print("error parsing JSON from google search")
                }
            }
            
        }.resume()
    }
    
    // downloads the image
    func getImage(_ link: String)->Data?{
        let url : URL = URL(string: link)!
        var imageData : Data?
     
        do {
            imageData = try Data(contentsOf: url)
        }catch{
            imageData = nil;
            print("Something wrong with the image download")
        }
        return imageData
    }
}
