//
//  ArrayResource.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation

struct ArrayResource: UrlResource {
    
    
     func getList() -> [HotUrl] {
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
