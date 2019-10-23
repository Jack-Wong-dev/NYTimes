//
//  LoginViewController.swift
//  JustUsLeagueNYTimes
//
//  Created by Jack Wong on 10/22/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    private let blackCat = CatView(frame: catFrame)
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Enter Email"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        textField.leftView = UIView(frame: frame)
        textField.leftViewMode = .always
        
        textField.rightView = UIView(frame: frame)
        textField.rightViewMode = .always
        
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter Password"
        
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.delegate = self
        
        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        textField.leftView = UIView(frame: frame)
        textField.leftViewMode = .always
        
        textField.rightView = UIView(frame: frame)
        textField.rightViewMode = .always
        
        
        textField.rightView = showHidePasswordButton
        showHidePasswordButton.isHidden = true
        return textField
    }()
    
    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: buttonVerticalMargin, left: 0, bottom: buttonVerticalMargin, right: buttonHorizontalMargin)
        button.frame = toggleButtonFrame
        button.tintColor = .black
        button.setImage(UIImage(named: "Password-show"), for: .normal)
        button.setImage(UIImage(named: "Password-hide"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        setUpEmailTextFieldConstraints()
        view.addSubview(passwordTextField)
        setUpPasswordTextFieldConstraints()
        
        
        view.addSubview(blackCat)
        setUpBlackCatContrainst()
        
        setUpGestures()
    }
    
    private func setUpBlackCatContrainst() {
        blackCat.translatesAutoresizingMaskIntoConstraints = false
        blackCat.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -10).isActive = true
        blackCat.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blackCat.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        blackCat.heightAnchor.constraint(equalToConstant: 200).isActive = true
        blackCat.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
    }
    
    private func setUpEmailTextFieldConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUpPasswordTextFieldConstraints() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldSpacing).isActive = true
    }
    
    
    private func stopHeadRotation() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordDidResignAsFirstResponder()
    }
    
    private func passwordDidResignAsFirstResponder() {
        showHidePasswordButton.isHidden = true
        showHidePasswordButton.isSelected = false
        passwordTextField.isSecureTextEntry = true
        blackCat.defaultCatState()
    }
    
    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        stopHeadRotation()
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        switch sender.isSelected {
        case true:
            blackCat.catPeeking()
        case false:
            blackCat.catEyesClosed()
        }
        
        
        let isPasswordVisible = sender.isSelected
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument), let password = passwordTextField.text {
            passwordTextField.replace(textRange, withText: password)
        }
    }
    
    @objc private func applicationDidEnterBackground() {
        stopHeadRotation()
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            self.passwordDidResignAsFirstResponder()
        }
        else if textField == passwordTextField {
            self.blackCat.catEyesClosed()
            self.showHidePasswordButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
            passwordDidResignAsFirstResponder()
            
            let tabBarController = TabBarViewController()
            //            navigationController?.pushViewController(tabBarController, animated: true)
            tabBarController.modalPresentationStyle = .fullScreen
            
            present(tabBarController, animated: true)
            //            showReddit()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
        }
    }
    
}



extension LoginViewController {
    
    
    //MARK:- Show Reddit
    func showAmazon() {
        if let url = URL(string: "https://amazon.com") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
        
    }
    
    //MARK: - Animate Objects
    func moveIt(_ imageView: UIImageView,_ speed:CGFloat) {
        let speeds = speed
        let imageSpeed = speeds / view.frame.size.width
        let averageSpeed = (view.frame.size.width - imageView.frame.origin.x) * imageSpeed
        UIView.animate(withDuration: TimeInterval(averageSpeed), delay: 0.0, options: .curveLinear, animations: {
            imageView.frame.origin.x = self.view.frame.size.width
        }, completion: { (_) in
            imageView.frame.origin.x = -imageView.frame.size.width
            self.moveIt(imageView,speeds)
        })
    }
}

private let toggleButtonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: toggleButtonHeight)
private let toggleButtonHeight = textFieldHeight
private let buttonHorizontalMargin = textFieldHorizontalMargin / 2
private let buttonImageDimension: CGFloat = 18
private let buttonVerticalMargin = (toggleButtonHeight - buttonImageDimension) / 2
private let buttonWidth = (textFieldHorizontalMargin / 2) + buttonImageDimension

private let textFieldHeight: CGFloat = 40
private let textFieldHorizontalMargin: CGFloat = 16.5
private let textFieldSpacing: CGFloat = 22
private let textFieldTopMargin: CGFloat = 38.8
private let textFieldWidth: CGFloat = 250

private let catViewDimension: CGFloat = 415
private let catFrame = CGRect(x: 0, y: 0, width: catViewDimension, height: 200)
private let critterViewTopMargin: CGFloat = 70


