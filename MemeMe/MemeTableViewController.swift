//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/13/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
}

