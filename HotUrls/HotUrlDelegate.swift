//
//  HotUrlDelegate.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 23.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation

protocol HotUrlDelegate {
    func hotUrlAdded(withName:String, andUrl: String)
}
