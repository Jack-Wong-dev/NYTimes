//
//  ViewController.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/18/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import UIKit
import AVFoundation

enum Identifiers:String{
    case bookCell
}

  let defaults = UserDefaults.standard

class BestSellersVC: UIViewController {
    //MARK: UI Objects
    

    var selectedCategory:String!{
        didSet{
            getBookData(category: selectedCategory)
        }
    }
    var isImageHidden = true
    var itemSize = CGSize(width: 250, height: 350)
    let cellSpacing = UIScreen.main.bounds.size.width * 0.09
    var initialConstraints = [NSLayoutConstraint]()
    var secondCondstraints = [NSLayoutConstraint]()
    
    //MARK: UI Objects
    lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView(image: "background", borderWidth: 0, borderColor: UIColor.clear.cgColor, contentMode: .scaleAspectFill)
        return iv
    }()
    
    lazy var nytImageView:UIImageView = {
        let iv = UIImageView(image: "TNYT", borderWidth: 0, borderColor: UIColor.clear.cgColor, contentMode: .scaleAspectFit)
        return iv
    }()
    
    
    lazy var bestSellerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.bookCell.rawValue)
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: Properties
    
    private var amazonBooks = [Book](){
        didSet{
            bestSellerCollectionView.reloadData()
        }
    }
    
//    private var googleBook = [VolumeInfo](){
//        didSet{
//            print("Got googleBook")
//            bestSellerCollectionView.reloadData()
//        }
//    }
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBackgroundImageConstraints()
        configureNytImageViewConstraints()
        configureBestSellerCollectionView()
        if let savedCategory = defaults.object(forKey: "selectedCategory") as? String {
            getBookData(category: savedCategory)
        } else {
            getBookData(category: "animals")
        }
        
    }
    
    private func getBookData(category:String){
        NYTimesAPIClient.manager.getBestSellersForGenre(genre: category) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let bestSeller):
                DispatchQueue.main.async {
                    self.amazonBooks = bestSeller.books
                    
                }
            }
        }
    }
    
    //MARK: Actions
    
    
    
    private func configureBackgroundImageConstraints() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), backgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), backgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func configureNytImageViewConstraints(){
        view.addSubview(nytImageView)
        nytImageView.translatesAutoresizingMaskIntoConstraints = false
        let leading = nytImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailing = nytImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let top = nytImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400)
        let bottom = nytImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        initialConstraints = [leading, trailing, top, bottom]
        NSLayoutConstraint.activate(initialConstraints)
    }
    
    private func configureBestSellerCollectionView() {
        view.addSubview(bestSellerCollectionView)
        bestSellerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([bestSellerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor), bestSellerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), bestSellerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), bestSellerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

extension BestSellersVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amazonBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.bookCell.rawValue, for: indexPath) as? BookCollectionViewCell else {return UICollectionViewCell()}
        
        let book = amazonBooks[indexPath.row]
        
        GoogleAPIClient.manager.getBookSummary(isbn: book.ISBN13 ) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let googleBookInfo):
                DispatchQueue.main.async {
                    if let googleinfo = googleBookInfo.volumeInfo{
                        cell.descriptionLabel.text = googleinfo.description
                    } else {
                        cell.descriptionLabel.text = book.description
                    }
                    
                }
            }
        }

        cell.actionSheetdelegate = self
        cell.delegate = self
        cell.favoriteButton.tag = indexPath.row
        cell.configureCell(with: book , collectionView: bestSellerCollectionView, index: indexPath.row)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell else {return}
        selectedCell.toggle()
        
    }
    
}

extension BestSellersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 0.8
        let numSpaces: CGFloat = numCells + 2.9
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    
}

extension BestSellersVC: hiddenSettingDelegate{
    func isHidden() {
        NSLayoutConstraint.deactivate(initialConstraints)
        self.nytImageView.alpha = 0
        
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
            let leading = self.nytImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 350)
            let trailing = self.nytImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            let top = self.nytImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 700)
            let bottom = self.nytImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            self.secondCondstraints = [leading, trailing, top, bottom]
            NSLayoutConstraint.activate(self.secondCondstraints)
        }, completion:  { (_) in
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.nytImageView.alpha = 1
            }, completion: nil)
        })
    }
    
    func isNotHidden() {
        self.nytImageView.alpha = 0
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            NSLayoutConstraint.deactivate(self.secondCondstraints)
            NSLayoutConstraint.activate(self.initialConstraints)
        }, completion: { (_) in
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.nytImageView.alpha = 1
            }, completion: nil)
        })
    }
    
}

extension BestSellersVC: CollectionViewCellDelegate{
    func actionSheet(tag: Int) {
        let currentBook = self.amazonBooks[tag]
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to add this book to your favorites?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .default) { (_) in
            let newFavorite = Favorite(date: Date(), weeks_on_list: currentBook.weeksOnList, description: currentBook.description, book_image: currentBook.bookImage, amazon_product_url: currentBook.amazonProductURL)
                      DispatchQueue.global(qos: .utility).async {
                          try? FavoritePersistenceHelper.manager.save(newFavorite: newFavorite)
                      }

            
            let successAlert = UIAlertController(title: "Success", message: "It has been added to your favorites", preferredStyle: .alert)
            let okbutton = UIAlertAction(title: "OK", style: .default, handler: nil)
            successAlert.addAction(okbutton)
            self.present(successAlert, animated: true, completion: nil)
        }
        let noButton = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
}
