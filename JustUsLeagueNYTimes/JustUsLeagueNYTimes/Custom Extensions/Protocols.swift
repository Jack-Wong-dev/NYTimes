//
//  Protocols.swift
//  RecipesAnimation
//
//  Created by Mr Wonderful on 10/18/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import Foundation

protocol hiddenSettingDelegate: AnyObject {
    func isHidden()
    func isNotHidden()
}


protocol FavoriteCellDelegate: AnyObject {
    func showActionSheet(tag: Int)
}
