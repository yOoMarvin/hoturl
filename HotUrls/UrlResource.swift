//
//  ArrayResource.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation
import CoreData

class UrlResource {
    //NOTE:
    //Actually there should be an implementation of the newer core data stack form iOS 10
    //Took the old one because there have to be made several adaptions for the share extension
    //Focus on the share extension for learning purposes
    
    
    //get the data model from the resource
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: "HotUrls", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: url)!
        
        return model
    }()
    
    private lazy var storeCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.documentDir.appendingPathComponent("HotUrls.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print(error)
        }
        
        return coordinator
    }()
    
    //Managed Context:
    //responsible for requests, changes etc.
    lazy var managedContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = self.storeCoordinator
        
        return context
    }()
    
    //
    lazy var documentDir: NSURL = {
        let allUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return allUrls.first! as NSURL
    }()
    
    
    //save changes
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                
            } catch {
                let nserror = error as NSError
                //fatal error for the purpose of this app is ok...
                fatalError("Error: \(nserror.localizedDescription)")
            }
        }
    }
    
    //add a new url
    func insertUrl(withName: String, andUrl: String) -> HotUrl {
        let newUrl = NSEntityDescription.insertNewObject(forEntityName: "HotUrl", into: managedContext) as! HotUrl
        
        newUrl.name = withName
        newUrl.url = andUrl
        
        saveContext()
        
        return newUrl
    }
    
    //remove a url
    func remove(hotUrl: HotUrl) {
        managedContext.delete(hotUrl)
        saveContext()
    }
    
    //get the existing urls from core data
    func getList() -> [HotUrl] {
        var hotUrls = [HotUrl]()
        let request: NSFetchRequest<HotUrl> = HotUrl.fetchRequest()
        
        do {
            hotUrls = try managedContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return hotUrls
    }
}
