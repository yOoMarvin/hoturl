//
//  UrlViewController.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 23.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import UIKit

class UrlViewController: UIViewController {
    
    //url view
    @IBOutlet weak var webView: UIWebView!
    
    var hotUrl: HotUrl?
    
    
    override func loadView() {
        super.loadView()
        
        guard let hotUrl = hotUrl else {
            return
        }
        
        guard let finalUrl = hotUrl.getPrefixedUrl() else {
            print("no prefixed url")
            return
        }
        
        if let url = URL(string: finalUrl) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
        
}
