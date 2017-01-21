//
//  ViewController.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 21.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import UIKit

class UrlListTableViewController: UITableViewController {

    var urlList = [HotUrl]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlList = appDelegate.urlResource.getList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        urlList = [HotUrl]()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        let hotUrl = urlList[indexPath.row]
        cell.textLabel?.text = hotUrl.name
        
        return cell
    }
    
}

