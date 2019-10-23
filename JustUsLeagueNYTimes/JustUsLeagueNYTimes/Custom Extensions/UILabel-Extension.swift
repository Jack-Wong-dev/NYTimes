//
//  UILabel-Extension.swift
//  RecipesAnimation
//
//  Created by Mr Wonderful on 10/19/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    public convenience init(textAlignment:NSTextAlignment){
        self.init()
        self.numberOfLines = 0
        self.textColor = .black
        self.textAlignment = textAlignment
}
}
