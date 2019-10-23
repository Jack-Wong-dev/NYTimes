//
//  CatAvatar.swift
//  JustUsLeagueNYTimes
//
//  Created by Jack Wong on 10/22/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import UIKit

class Head: UIImageView{
    
    convenience init() {
        self.init(image: UIImage(named: "defaultKitty"))
        frame = CGRect(x: 0, y: 0, width: 415, height: 200)
        //        frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
    }
}

class CatView: UIView {
    
    private var head = Head()
    
    override func didMoveToSuperview() {
           super.didMoveToSuperview()
           setUpView()
            
       }
    
    private func setUpView(){
        backgroundColor = .white
        setUpMask()
        
        addSubview(head)
        
    }
    
   
    func defaultCatState(){
        head.image = UIImage(named: "defaultKitty")
    }
    
    func catEyesClosed(){
         head.image = UIImage(named: "kittyEyesClosed")
    }
    
    func catPeeking(){
        head.image = UIImage(named: "kittyPeeking")
    }
    
    private func setUpMask() {
        mask = UIView(frame: bounds)
        mask?.backgroundColor = .black
//        mask?.layer.cornerRadius = bounds.width / 2

    }
    
}

