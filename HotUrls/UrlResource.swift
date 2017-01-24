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
    
    
     func getList() -> [HotUrl] {
        //return a static array of hot url objects
        //array can be declared inside because it won't be changed outside
        var hotUrls = [HotUrl]()
        
        hotUrls.append(HotUrl(name: "Interface Guidelines",
                              url: "https://developer.apple.com/ios/human-interface-guidelines/overview/design-principles/",
                              comment: "Interface guidlines from apple"))
        hotUrls.append(HotUrl(name: "Spiegel",
                              url: "https://spiegel.de",
                              comment: "German news magazine"))
        
        return hotUrls
    }
}
