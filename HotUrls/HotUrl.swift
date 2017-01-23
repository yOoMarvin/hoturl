//
//  HotUrl.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation

struct HotUrl {
    var name: String
    var url: String
    
    func getPrefixedUrl() -> String {
        if url.range(of: "^(http|https)", options: .regularExpression, range: nil, locale: nil) != nil {
            return url
        }
        
        return "http://\(url)"
    }
}
