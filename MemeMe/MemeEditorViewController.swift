//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/15/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
 
    //Define my variables
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    @IBOutlet weak var topShelf: UIToolbar!
    @IBOutlet weak var bottomShelf: UIToolbar!

    //Define my text for my memes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 48)!,
        NSStrokeWidthAttributeName : -3.0        ]
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera when not enabled
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Style text
        topText.tag = 1
        bottomText.tag = 2
        styleTextField(topText)
        styleTextField(bottomText)

        //Subscribe to keyboard notification events
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Register delegates
        topText.delegate = topTextFieldDelegate
        bottomText.delegate = bottomTextFieldDelegate
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Subscribe to keyboard unsubscribe events
        unsubscribeFromKeyboardNotifications()
    }
    
    func styleTextField(textField: UITextField){
        
        //Style our text fields
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = .None
        textField.textAlignment = NSTextAlignment.Center
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        //Keyboard is going to appear. Change the height.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //Keyboard closing. Bring y axis back
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            //Bring up y axis by keyboard height
            view.frame.origin.y -= getKeyboardHeight(notification)
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {

        if bottomText.isFirstResponder()
        {
            //Reset keyboard value
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //Get the height of the keyboard
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        var memes: [Meme]!
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        //Album clicked
        imagePickerRegister("Photo")
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        //Camera picked
        imagePickerRegister("Camera")
    }
    
    func imagePickerRegister(type : String){
        
        //Figure out which resource to call
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = (type == "Photo") ? UIImagePickerControllerSourceType.PhotoLibrary : UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
        shareBtn.enabled = true //Enable share button after image picked.
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            
            //Post selected image to screen
            if let image: AnyObject = info["UIImagePickerControllerOriginalImage"] {
                imageView.image = image as? UIImage
                dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    @IBAction func memeEditorControllerDidCancel(sender: UIBarButtonItem) {
        
        //Handle canceled image picker
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func shareButton(sender: UIBarButtonItem) {
      
        //Call UIActivityViewController
        var memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

       //Handler for completion
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
           
            if(success == true)
            {
                //Generate a memed image
                self.save(memedImage);
                
                //Dismiss
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }

        presentViewController(activityViewController,
            animated: true,
            completion: nil)
        
    }
    
    func save(memedImage : UIImage) {
        
        var meme = Meme(topText: topText.text, bottomText : bottomText.text, image:
            imageView.image, memedImage: memedImage)
        
        //Add meme to array in app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        let myMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar
        topShelf.hidden = true
        bottomShelf.hidden = true
        
        navigationController?.navigationBar.hidden = true
        navigationController?.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar
        topShelf.hidden = false
        bottomShelf.hidden = false
        
        return memedImage
    }
    
    
}