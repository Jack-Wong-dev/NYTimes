//
//  FavoritedBookCollectionViewCell.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/18/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import UIKit

class FavoritedBookCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: FavoriteCellDelegate?
    
    lazy var imageOutlet: UIImageView = {
        var image = UIImageView(borderWidth: 1.0, borderColor: UIColor.black.cgColor, contentMode: .scaleAspectFill)
        image.frame = CGRect(x: 90, y: 10, width: 125, height: 175)
        return image
    }()
    
    lazy var bestSellingTimeLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 35, y: 190, width: 220, height: 30)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        return label
    }()
    
    lazy var bookDescriptionLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: 35, y: 225, width: 220, height: 120)
        label.textAlignment = .center
        label.numberOfLines = 7
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.frame = CGRect(x: 220, y: 150, width: 50, height: 35)
        button.addTarget(self, action: #selector(optionsButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func optionsButtonPressed(sender: UIButton) {
        delegate?.showActionSheet(tag: sender.tag)
    }
    
    override init(frame: CGRect) {
           super.init(frame:.zero)
            addSubviews()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    private func addSubviews() {
        contentView.addSubview(imageOutlet)
        contentView.addSubview(bestSellingTimeLabel)
        contentView.addSubview(bookDescriptionLabel)
        contentView.addSubview(optionsButton)
        self.layer.borderWidth = 1
    }
    
    func configureCell(favoritedPhoto: Favorite) {
        
        switch favoritedPhoto.weeks_on_list {
        case 0:
             bestSellingTimeLabel.text = "New!"
        case 1:
            bestSellingTimeLabel.text = "\(favoritedPhoto.weeks_on_list) week on best seller list"
        default:
             bestSellingTimeLabel.text = "\(favoritedPhoto.weeks_on_list) weeks on best seller list"
        }
        bookDescriptionLabel.text = favoritedPhoto.description
        
        ImageHelper.shared.getImage(url: favoritedPhoto.book_image) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    self.imageOutlet.image = imageFromOnline
                }
            }
        }
    }
}





