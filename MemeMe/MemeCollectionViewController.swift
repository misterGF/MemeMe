//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/13/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//
import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

    var memes: [Meme]!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
 
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        self.memes = applicationDelegate.memes
        self.collectionView!.reloadData()

    }

    //Function for count
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Function for displaying cellsUICollectionViewController
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage

        return cell
    }
    
    //Function for tap request
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.memeNumber = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}

