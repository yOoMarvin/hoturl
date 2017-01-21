//
//  UrlResource.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation

protocol UrlResource {
    func getList() -> [HotUrl]
}
