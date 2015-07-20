//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/13/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//
import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }



}

