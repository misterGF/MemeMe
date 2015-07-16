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
    var keyboardHeight: CGFloat!
    
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
        topText.textAlignment = .Center
        topText.defaultTextAttributes = memeTextAttributes
        topText.delegate = self
        
        //Pre-fill bottom text
        bottomText.placeholder = "Bottom"
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
    
    func subscribeToKeyboardNotifications() {
        
        //Keyboard is going to appear. Change the hight.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //Keyboard closing. Bring y axis back
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        //Bring up y axis by keyboard height
        keyboardHeight = getKeyboardHeight(notification)
        self.view.frame.origin.y -= keyboardHeight
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //Reset keyboard value
        self.view.frame.origin.y += keyboardHeight
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
        println("Photo button clicked.")
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        //Handle canceled image picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        
        //Create the meme
        var memedImage = generateMemedImage()
        
        var meme = Meme(top: topText.text, bottom: bottomText.text, image:
            imageView.image, memedImage: memedImage)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.toolbar.hidden = false
        
        return memedImage
    }
    
    
}