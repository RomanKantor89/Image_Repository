//
//  CoreDataManager.swift
//  Image Repository
//
//  Created by Eden Giterman on 2021-01-06.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static var shared = CoreDataManager()
        
    // fetch result controller to update the table
    lazy var frc : NSFetchedResultsController<Image> = {
        let fetch : NSFetchRequest<Image> = Image.fetchRequest()
    
        fetch.sortDescriptors = [NSSortDescriptor(key: "imgSource", ascending: true)]
        
        let result = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return result
    }()
    
    
    
    // add new image to favorites and save to Core Data
    func addImage(_ image: Data, _ allImages: [Image]) {
        var recordExists = false;
        
        //check if selected location already saved
        for img in allImages {
            
            if img.imgSource == image {
                recordExists = true;
            }
        }
        
        if !recordExists {
           let newImage = Image(context: persistentContainer.viewContext)
            newImage.imgSource = image
           
           saveContext()
        }
    }
    
    // delete image
    func deleteImage(_ imageToDelete: Image) {
        persistentContainer.viewContext.delete(imageToDelete)
        saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Image_Repository")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
