//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/13/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//
import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource{

    var memes: [Meme]!
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.memes == nil{
            return 0
        }
        else{
          return self.memes.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.memeNumber = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}

