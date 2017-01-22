//
//  AddViewController.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 22.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    //outlets for ui elements
    @IBOutlet weak var nameAudioBtn: UIButton!
    @IBOutlet weak var urlAudioBtn: UIButton!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    
    //button action
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
