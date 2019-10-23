//
//  FavoritesVC.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/18/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import UIKit
import SafariServices

class FavoritesVC: UIViewController {
   
    //MARK: UI Objects
    
    lazy var collectionOutlet: UICollectionView = { [unowned self] in
           let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

           let collectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
           collectionView.backgroundColor = .white
           collectionView.register(FavoritedBookCollectionViewCell.self, forCellWithReuseIdentifier: "favorite")
           return collectionView
       }()
    
    //MARK: Properties
    
    var favorites = [Favorite]()
      
       
    
    //MARK: LifeCycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUp()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
        loadData()
    }
    
    //MARK: Methods
    
    private func setUp() {
        view.backgroundColor = .lightGray
        view.addSubview(collectionOutlet)
        collectionOutlet.delegate = self
        collectionOutlet.dataSource = self
        collectionOutlet.backgroundColor = .lightGray
        
    }
    
    private func loadData() {
        do {
                 favorites = try FavoritePersistenceHelper.manager.getFavorites()
             } catch {
                 print(error)
             }
                 collectionOutlet.reloadData()
    }
    
    func showAmazon(link: URL){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: link, configuration: config)
            present(vc, animated: true)
    }
    
}

//MARK: CollectionView Extensions

extension FavoritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionOutlet.dequeueReusableCell(withReuseIdentifier: "favorite", for: indexPath) as! FavoritedBookCollectionViewCell
        let favorite = favorites[indexPath.row]
        CustomLayer.shared.createCustomlayer(layer: cell.layer)
        cell.configureCell(favoritedPhoto: favorite)
        cell.delegate = self
        cell.optionsButton.tag = indexPath.row
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 400)
    }
    
}


extension FavoritesVC: FavoriteCellDelegate {
    
    func showActionSheet(tag: Int) {
        
        let favorite = self.favorites[tag]
        
        let optionsMenu = UIAlertController(title: "Options", message: "Select an action.", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            DispatchQueue.global(qos: .utility).async {
                try? FavoritePersistenceHelper.manager.deleteFavorite(withDate: favorite.date)
            }
            DispatchQueue.main.async {
                 self.loadData()
            }
           
        }
        
        let amazonAction = UIAlertAction(title: "See on Amazon", style: .default) { (action) in
            self.showAmazon(link: favorite.amazon_product_url)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionsMenu.addAction(deleteAction)
        optionsMenu.addAction(cancelAction)
        optionsMenu.addAction(amazonAction)
        
        present(optionsMenu, animated: true )
    }
    
    
    
    
}
