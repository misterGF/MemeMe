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
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var topShelf: UIToolbar!
    @IBOutlet weak var bottomShelf: UIToolbar!

    var keyboardHeight: CGFloat!
    var liftScreen = false //Controll for when top text is selected
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable camera when not enabled
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Define my text for my memes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 48)!,
            NSStrokeWidthAttributeName : -3.0        ]
        
        //Pre-fill top text
        topText.placeholder = "Top"
        topText.tag = 1
        topText.textAlignment = .Center
        topText.defaultTextAttributes = memeTextAttributes
        topText.delegate = self
        
        //Pre-fill bottom text
        bottomText.placeholder = "Bottom"
        bottomText.tag = 2
        bottomText.textAlignment = .Center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Subscribe to keyboard notification events
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Subscribe to keyboard unsubscribe events
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
       
        //Check which text was selected and keep it handy
       if(textField.tag == 1)
       {
            liftScreen = false
        }
        else
       {
            liftScreen = true
        }

        return true
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
        
        if(liftScreen)
        {
            //Bring up y axis by keyboard height
            keyboardHeight = getKeyboardHeight(notification)
            self.view.frame.origin.y -= keyboardHeight
            
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {

        if(liftScreen)
        {
            //Reset keyboard value
            keyboardHeight = getKeyboardHeight(notification)
            self.view.frame.origin.y += keyboardHeight
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //Get the height of the keyboard
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        //Album clicked
        imagePickerRegister("Photo")
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        //Camera picked
        imagePickerRegister("Camera")
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Close keyboard on enter
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerRegister(type : String){
        
        //Figure out which resource to call
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = (type == "Photo") ? UIImagePickerControllerSourceType.PhotoLibrary : UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        shareBtn.enabled = true //Enable share button after image picked.
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            
            //Post selected image to screen
            if let image: AnyObject = info["UIImagePickerControllerOriginalImage"] {
                self.imageView.image = image as? UIImage
                self.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    @IBAction func memeEditorControllerDidCancel(sender: UIBarButtonItem) {
        
        //Handle canceled image picker
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
 /*
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        //Handle canceled image picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 */
    @IBAction func shareButton(sender: UIBarButtonItem) {
      
        //Call UIActivityViewController
        var memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

       //Handler for completion
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            
            //Generate a memed image
            self.save(memedImage);
            
            //Dismiss
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }

        self.presentViewController(activityViewController,
            animated: true,
            completion: nil)
        
    }
    
    func save(memedImage : UIImage) {
        
        var meme = Meme(top: topText.text, bottom: bottomText.text, image:
            imageView.image, memedImage: memedImage)
        
        //Add meme to array in app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        let myMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        println("Printed memes")
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar
        self.topShelf.hidden = true
        self.bottomShelf.hidden = true
        
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        //self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: false)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar
        self.topShelf.hidden = false
        self.bottomShelf.hidden = false
        
        return memedImage
    }
    
    
}