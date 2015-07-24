//
//  TopTextFieldDelegate.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/22/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Check if default text is there. If so clear it
        if textField.text == "TOP" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Keyboard return
        textField.resignFirstResponder()
        return true
    }
}