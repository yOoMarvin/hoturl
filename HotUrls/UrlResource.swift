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
    
    lazy var managedContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = self.storeCoordinator
        
        return context
    }()
    
    lazy var documentDir: NSURL = {
        let allUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return allUrls.first! as NSURL
    }()
    
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
    
    func insertUrl(withName: String, andUrl: String) -> HotUrl {
        let newUrl = NSEntityDescription.insertNewObject(forEntityName: "HotUrl", into: managedContext) as! HotUrl
        
        newUrl.name = withName
        newUrl.url = andUrl
        
        saveContext()
        
        return newUrl
    }
    
    func remove(hotUrl: HotUrl) {
        managedContext.delete(hotUrl)
        saveContext()
    }
    
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
