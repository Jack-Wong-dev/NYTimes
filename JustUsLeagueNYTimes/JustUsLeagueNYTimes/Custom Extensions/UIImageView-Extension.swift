//
//  UIImageView-Extension.swift
//  RecipesAnimation
//
//  Created by Mr Wonderful on 10/19/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    public convenience init(image:String, borderWidth:CGFloat, borderColor:CGColor, contentMode:UIView.ContentMode ){
        self.init()
        self.image = UIImage(named: image)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.contentMode = contentMode
      
    }
    
    convenience init(borderWidth:CGFloat, borderColor:CGColor, contentMode:UIView.ContentMode){
        self.init()
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.contentMode = contentMode
        self.clipsToBounds = true
        self.alpha = 0.7
    }
}
