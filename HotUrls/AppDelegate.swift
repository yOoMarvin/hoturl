//
//  AppDelegate.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let ISPRELOADED = "isPreloaded"

    var window: UIWindow?
    //init resource model - should actually not be coded here...
    var urlResource: UrlResource = UrlResource()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        startPreload()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    //preload
    private func startPreload() {
        //use user defaults, so preload is only added once
        if UserDefaults.standard.bool(forKey: ISPRELOADED){
            return
        }
        
        let urls = readPreload()
        let _ = urlResource.insertUrl(withName: urls["name"]!, andUrl: urls["url"]!, andComment: urls["comment"]!)
        
        //set user default
        UserDefaults.standard.set(true, forKey: ISPRELOADED)
    }
    
    private func readPreload() -> [String: String] {
        var preparedUrls = [String: String]()
        //reference in file system
        let preloadFileUrl = Bundle.main.url(forResource: "preload", withExtension: "json")
        
        do {
            guard let fileUrl = preloadFileUrl else {
                return preparedUrls
            }
            let data = try Data(contentsOf: fileUrl)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            let urlArray = json["urls"] as! NSArray
            for url in urlArray{
                let urlDict = url as! NSDictionary
                let name = urlDict["name"] as! String
                let url = urlDict["url"] as! String
                let comment = urlDict["comment"] as! String
                
                //only one entry in preload.json so elements can be added like this
                //otherwise another data type is needed
                preparedUrls["name"] = name
                preparedUrls["url"] = url
                preparedUrls["comment"] = comment
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return preparedUrls
    }


}

