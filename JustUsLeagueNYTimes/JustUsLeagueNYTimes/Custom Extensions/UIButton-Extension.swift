//
//  UIButton-Extension.swift
//  RecipesAnimation
//
//  Created by Mr Wonderful on 10/19/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    public convenience init(alpha:CGFloat, image:UIImage, contentMode: UIView.ContentMode){
        self.init()
        self.setImage(image, for: .normal)
        self.alpha = alpha
        self.contentMode = contentMode
    }
}

