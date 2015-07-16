//
//  MemeClass.swift
//  MemeMe
//
//  Created by Gil Ferreira on 7/15/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var top : String!
    var bottom : String!
    var image: UIImage?
    var memedImage: UIImage?
    
    init(top : String?, bottom : String?, image: UIImage?, memedImage: UIImage?){
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memedImage = memedImage
    }
}