//
//  SettingsCategoryCollectionViewCell.swift
//  JustUsLeagueNYTimes
//
//  Created by Jason Ruan on 10/21/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import UIKit

class SettingsCategoryCollectionViewCell: UICollectionViewCell {
    //MARK: UI Objects
    lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .black
        button.setTitleColor(.black, for: .normal)
        
        button.titleEdgeInsets.left = 5
        button.titleEdgeInsets.right = 5
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = button.layer.frame.height / 2
        
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        return button
    }()
    
    //MARK:
    var chosenCategory: String?
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        configureButtonConstraints()
        addShadowToViewA()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Constraints
    private func configureButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            button.widthAnchor.constraint(equalToConstant: contentView.frame.width - 15)
        ])
        button.layer.cornerRadius = button.frame.height - 100
    }
    
    private func addShadowToViewA() {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.contentView.layer.cornerRadius = 2
    }
    
}
