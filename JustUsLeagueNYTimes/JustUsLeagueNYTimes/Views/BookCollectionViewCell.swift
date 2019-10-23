//
//  BookCollectionViewCell.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/18/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import UIKit
import AVFoundation

protocol CollectionViewCellDelegate: AnyObject {
    func actionSheet(tag: Int)
}

class BookCollectionViewCell: UICollectionViewCell {
    
    //MARK: UIOBJECTS
    
    
    var isSpeaking = true
    weak var delegate: hiddenSettingDelegate?
    weak var actionSheetdelegate: CollectionViewCellDelegate?
    var imageIsHidden = false
    
    lazy var bookImageView: UIImageView = {
        let imageView = UIImageView(borderWidth: 2, borderColor: UIColor.clear.cgColor, contentMode: .scaleAspectFit)
        return imageView
    }()
    
    lazy var weeksOnListLabel: UILabel = {
        let label = UILabel(textAlignment: .center)
        label.font = UIFont(name: "Noteworthy-Bold", size: 20)
        return label
    }()
    
    lazy var miniDescriptionLabel:UILabel = {
        let label = UILabel(textAlignment: .center)
        label.alpha = 1
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's..."
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel(textAlignment: .left)
        label.alpha = 0
        label.font = UIFont(name: "System", size: 17)
        label.clipsToBounds = false
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(alpha: 0, image: UIImage(systemName: "xmark.circle")!, contentMode: .scaleAspectFill)
        button.addTarget(self, action: #selector(closedButtonPressed), for: .touchUpInside)
        button.tintColor = .red
        return button
    }()
    
    lazy var favoriteButton:UIButton = {
        let button = UIButton(alpha: 0, image: UIImage(systemName: "heart")!, contentMode: .scaleAspectFill)
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
         button.tintColor = .black
        return button
    }()
    
    lazy var speechButton:UIButton = {
         let button = UIButton(alpha: 0, image:  UIImage(systemName: "mic")!, contentMode: .scaleAspectFill)
          button.tintColor = .black
          button.addTarget(self, action: #selector(handleSpeechButton), for: .touchUpInside)
         return button
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBookImageViewConstraints()
        configureWeeksOnListLabel()
        configureDescriptionLabelConstraints()
        configureMiniDescriptionLabelConstraints()
        configureCloseButtonConstraints()
        configureFavoriteButtonPressed()
        configureSpeechButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    enum State {
        case expanded
        case collapsed
        
        var change:State{
            switch self {
            case .expanded: return .collapsed
            case .collapsed: return .expanded
            }
        }
    }
    
    //MARK: Properties
    
    private var initialFrame: CGRect?
    var state: State = .collapsed
    private var collectionview: UICollectionView?
    private var index:Int?
    
    enum hiddenSettingState: String {
        case on
        case off
    }
    let sync = AVSpeechSynthesizer()
    @objc private func handleSpeechButton(){
        
        switch isSpeaking{
        case true:
            speechButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
             speechButton.tintColor = .red

                   let utterance = AVSpeechUtterance(string: "Hello David, the summary of this book is, \(String(describing: self.descriptionLabel.text))")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    sync.speak(utterance)
            isSpeaking = false
        case false:
            speechButton.tintColor = .black
             speechButton.setImage(UIImage(systemName: "mic"), for: .normal)
            sync.stopSpeaking(at: .immediate)
            isSpeaking = true
        }
       }
    
    private func setImageAlpha(setting: hiddenSettingState) {
        switch setting {
        case .on :
            delegate?.isHidden()
        case .off:
            delegate?.isNotHidden()
        }
    }
    //MARK: Cell Animations
    private func collapsed(){
        // collapse the cell
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            guard let collectionVC = self.collectionview, let index = self.index else {return}
            self.descriptionLabel.alpha = 0
            self.miniDescriptionLabel.alpha = 1
            self.closeButton.alpha = 0
            self.favoriteButton.alpha = 0
            self.setImageAlpha(setting: .off)
            self.speechButton.alpha = 0
            self.speechButton.isEnabled = false
            self.bookImageView.transform = .identity
            
            self.frame = self.initialFrame!
            if let leftCell = collectionVC.cellForItem(at: IndexPath(row: index - 1, section: 0)){
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    leftCell.center.x += 50
                    leftCell.alpha = 1
                }, completion: nil)
            }
            if let rightCell = collectionVC.cellForItem(at: IndexPath(row: index + 1, section: 0)){
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    rightCell.center.x -= 50
                    rightCell.alpha = 1
                }, completion: nil)
            }
        }) { (finished) in
            self.state = self.state.change
            self.collectionview?.isScrollEnabled = true
            self.collectionview?.allowsSelection = true
        }
    }
    
    private func expand(){
        // expand the cell
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            guard let collectionView = self.collectionview, let index = self.index else {return}
            self.bookImageView.layer.cornerRadius = 0
            self.initialFrame = self.frame
            self.descriptionLabel.alpha = 1
            self.miniDescriptionLabel.alpha = 0
            self.closeButton.alpha = 1
            self.favoriteButton.alpha = 1
            self.speechButton.alpha = 1
            self.speechButton.isEnabled = true
             self.bookImageView.transform = CGAffineTransform(scaleX: 1.37, y: 1.37)
            self.setImageAlpha(setting: .on)
            
            self.frame = CGRect(x: collectionView.contentOffset.x, y: 40, width: collectionView.frame.width, height: collectionView.frame.height)
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)){
                //Animates left Cell fading out when cell expands
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    leftCell.center.x -= 50
                    leftCell.alpha = 0
                }, completion: nil)
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)){
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    rightCell.center.x += 50
                    rightCell.alpha = 0
                }, completion: nil)
            }
        }) { (finished) in
            self.state = self.state.change
            self.collectionview?.isScrollEnabled = false
            self.collectionview?.allowsSelection = false
        }
    }
    
    
    @objc func closedButtonPressed(){
        self.toggle()
    }
    
    @objc func favoriteButtonPressed(_ sender:UIButton){
        actionSheetdelegate?.actionSheet(tag: sender.tag)
    }
    
    public func toggle(){
        switch state{
        case .expanded:
            collapsed()
        case .collapsed:
            expand()
        }
    }
    
    
    public func configureCell(with book: Book, collectionView: UICollectionView, index:Int) {
        self.collectionview = collectionView
        self.index = index
        weeksOnListLabel.text = "\(book.weeksOnList) weeks on the best seller list"
        miniDescriptionLabel.text = book.description
        
        
        ImageHelper.shared.getImage(url: book.bookImage) { (result) in
            switch result{
            case .failure( let error):
                print(error)
            case .success(let image):
                DispatchQueue.main.async {
                    self.bookImageView.image = image
                }
            }
        }
    }
    
    
    
    private func configureBookImageViewConstraints() {
        addSubview(bookImageView)
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([bookImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor), bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50), bookImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50), bookImageView.heightAnchor.constraint(equalToConstant: 210)])
        
    }
    
    
    private func configureWeeksOnListLabel() {
        addSubview(weeksOnListLabel)
        weeksOnListLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([weeksOnListLabel.centerXAnchor.constraint(equalTo: bookImageView.centerXAnchor), weeksOnListLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 40), weeksOnListLabel.heightAnchor.constraint(equalToConstant: 30)])
        
    }
    
    private func configureMiniDescriptionLabelConstraints(){
        addSubview(miniDescriptionLabel)
        
        miniDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([miniDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor), miniDescriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300), miniDescriptionLabel.topAnchor.constraint(equalTo: weeksOnListLabel.bottomAnchor, constant: 10)])
        
    }
    
    private func configureDescriptionLabelConstraints() {
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor), descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300), descriptionLabel.topAnchor.constraint(equalTo: weeksOnListLabel.bottomAnchor, constant: 25), descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -100)])
    }
    
    private func configureCloseButtonConstraints() {
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor), closeButton.widthAnchor.constraint(equalToConstant: 30), closeButton.topAnchor.constraint(equalTo: self.topAnchor), closeButton.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    private func configureFavoriteButtonPressed(){
        addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([favoriteButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60), favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor),favoriteButton.heightAnchor.constraint(equalToConstant: 30), favoriteButton.widthAnchor.constraint(equalToConstant: 30)])
    }
    private func configureSpeechButton(){
          addSubview(speechButton)
           speechButton.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([speechButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60), speechButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),speechButton.heightAnchor.constraint(equalToConstant: 30), speechButton.widthAnchor.constraint(equalToConstant: 30)])
       }
    
}
