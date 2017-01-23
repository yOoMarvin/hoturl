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
    
    //segue (actions)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUrl" {
            let dst = segue.destination as! AddViewController
            dst.delegate = self
        }
        if segue.identifier == "detailView" {
            let dst = segue.destination as! UrlViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {
                //early exit
                return
            }
            dst.hotUrl = urlList[indexPath.row]
        }
    }
    
}

extension UrlListTableViewController: HotUrlDelegate {
    
    func hotUrlAdded(withName:String, andUrl: String){
        let newUrl = HotUrl(name: withName, url: andUrl)
        urlList.append(newUrl)
    }
}

