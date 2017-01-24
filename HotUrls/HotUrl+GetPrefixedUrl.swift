//
//  HotUrl.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation

extension HotUrl {

    
    func getPrefixedUrl() -> String? {
        guard let url = url else {
            return nil
        }
        
        //http or https at the beginning
        // ok: http
        // ok: https
        // not ok: www.google.de/httperror
        if url.range(of: "^(http|https)", options: .regularExpression, range: nil, locale: nil) != nil {
            return url
        }
        
        return "http://\(url)"
    }
}
