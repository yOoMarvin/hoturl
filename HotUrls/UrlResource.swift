//
//  ArrayResource.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation
import CoreData

struct UrlResource {
    
    //persistent container for core data
    var persistentContainer: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "HotUrls")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                let nserror = error as NSError
                //fatal error for the purpose of this app ok...
                fatalError("Fehler: \(nserror.localizedDescription)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                //fatal error for the purpose of this app ok...
                fatalError("Fehler: \(nserror.localizedDescription)")
            }
        }
    }
    
    
    func insertUrl(withName: String, andUrl: String, andComment: String) -> HotUrl {
        let newUrl = NSEntityDescription.insertNewObject(forEntityName: "HotUrl", into: persistentContainer.viewContext) as! HotUrl
        newUrl.name = withName
        newUrl.url = andUrl
        newUrl.comment = andComment
        
        saveContext()
        
        return newUrl
    }
    
    
    func remove(hotUrl: HotUrl) {
        persistentContainer.viewContext.delete(hotUrl)
        saveContext()
    }
    
    
     func getList() -> [HotUrl] {
        //return a static array of hot url objects
        //array can be declared inside because it won't be changed outside
        var hotUrls = [HotUrl]()
        
        //deleted the static entries. Now fetched from core data
        let request: NSFetchRequest<HotUrl> = HotUrl.fetchRequest()
        do {
            hotUrls = try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return hotUrls
    }
}
