//
//  SettingsVC.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/18/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    //MARK: UI Objects
    
    var info = ""
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 200, height: 50)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.register(SettingsCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "settingsCategoryCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    lazy var witchImageOutlet: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: 50, y: 50, width: 125, height: 125)
        image.image = UIImage(named: "sprite_00")
        image.alpha = 0
        return image
    }()
    
    //MARK: Properties
    var categories = [Genre]() {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    var chosenCategory: String? {
        didSet {
            categoryCollectionView.reloadData()
        }
    }
    
    
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reloadChosenCategory()
        getCategoryOptions()
        addSubviews()
        configureCategoriesCollectionViewConstraints()
        if let cat = defaults.object(forKey: "selectedCategory") as? String {
            self.chosenCategory = cat
        } else {
            self.chosenCategory = "manga"
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        if let selectedCategory = self.chosenCategory {
    //            guard let bestSellersVC = tabBarController?.viewControllers?[0] as? BestSellersVC else {
    //                print("Could not find instance of BestSellersVC")
    //                return
    //            }
    //            //            bestSellersVC.selectedCategory = selectedCategory
    //        }
    //    }
    
    
    //MARK: Actions
    private func getCategoryOptions() {
        NYTimesAPIClient.manager.getGenres { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let genres):
                DispatchQueue.main.async {
                    self.categories = genres
                }
            }
        }
        
    }
    
    private func addSubviews() {
        view.addSubview(categoryCollectionView)
        view.addSubview(witchImageOutlet)
    }
    
    private func configureCategoriesCollectionViewConstraints() {
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func reloadChosenCategory() {
        if let savedCategory = defaults.object(forKey: "selectedCategory") as? String {
            chosenCategory = savedCategory
        }
    }
    
    @objc private func setCategory(sender: UIButton) {
        //        let encodedName = categories[sender.tag].listNameEncoded
        //        defaults.set(encodedName, forKey: "selectedCategory")
        //        guard let bestSellersVC = tabBarController?.viewControllers?[0] as? BestSellersVC else {
        //            return
        //        }
        //        chosenCategory = encodedName
        //        bestSellersVC.selectedCategory = encodedName
        
        guard let frame = sender.superview?.convert(sender.frame, to: self.view) else { return }
        witchImageOutlet.alpha = 1
        
        if frame.minX - 10 > self.view.frame.minX {
            witchImageOutlet.frame = CGRect(x: self.view.frame.minX, y: frame.minY - 30, width: 125, height: 125)
            witchImageOutlet.image = UIImage(named: "sprite_reversed_0")
        } else {
            witchImageOutlet.frame = CGRect(x: self.view.frame.maxX, y: frame.minY - 30, width: 125, height: 125)
            witchImageOutlet.image = UIImage(named: "sprite_00")
        }
        
        UIView.transition(with: witchImageOutlet, duration: 0.5, options: [.transitionCrossDissolve, .curveLinear], animations: {
            if self.witchImageOutlet.layer.frame.minX > self.view.frame.minX {
                self.witchImageOutlet.transform = CGAffineTransform(translationX: -300, y: 0)
                print(1)
            } else {
                self.witchImageOutlet.transform = CGAffineTransform(translationX: 200, y: 0)
                print(2)
            }
        }) { (_) in
            UIView.transition(with: self.witchImageOutlet, duration: 0.5, options: .transitionCrossDissolve, animations: {
                if self.witchImageOutlet.image == UIImage(named: "sprite_00") {
                    self.witchImageOutlet.image = UIImage(named: "sprite_01")
                } else {
                    self.witchImageOutlet.image = UIImage(named: "sprite_reversed_1")
                }
            }) { (_) in
                UIView.transition(with: self.witchImageOutlet, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.witchImageOutlet.image = UIImage(named: "sprite_02")
                }) { (_) in
                    UIView.transition(with: self.witchImageOutlet, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.witchImageOutlet.image = UIImage(named: "sprite_03")
                    }) { (_) in
                        self.witchImageOutlet.alpha = 0
                        self.witchImageOutlet.transform = .identity
                    }
                }
            }
        }
    }
}

extension SettingsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCategoryCell", for: indexPath) as! SettingsCategoryCollectionViewCell
        let currentCategory = categories[indexPath.row]
        cell.button.setTitle(currentCategory.displayName, for: .normal)
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(setCategory(sender:)), for: .touchUpInside)
        if currentCategory.listNameEncoded == chosenCategory {
            cell.button.backgroundColor = .yellow
            cell.button.setTitleColor(.blue, for: .normal)
            cell.button.layer.borderWidth = 1
            cell.button.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.button.backgroundColor = .white
            cell.button.setTitleColor(.black, for: .normal)
            cell.button.layer.borderWidth = 2
            cell.button.layer.borderColor = UIColor.black.cgColor
        }
        return cell
    }
    
}
