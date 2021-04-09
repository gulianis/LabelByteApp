//
//  RegisterView.swift
//  LabelByte
//
//  Created by Sandeep Guliani on 1/24/21.
//

import Foundation
import UIKit

class RegisterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewItems()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ViewItems()
    }
    
    let RegisterLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Register: "
        Label.font = Label.font.withSize(40)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let UsernameLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Enter Email:"
        Label.font = Label.font.withSize(13)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let Username: UITextField = {
        let Username = UITextField()
        Username.placeholder = "Enter Email"
        Username.borderStyle = UITextField.BorderStyle.roundedRect
        Username.font = UIFont.systemFont(ofSize: 15)
        Username.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        Username.autocapitalizationType = .none
        Username.translatesAutoresizingMaskIntoConstraints = false
        return Username
    }()
    
    let PasswordLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Enter Password:"
        Label.font = Label.font.withSize(13)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let Password: UITextField = {
        let Username = UITextField()
        Username.placeholder = "Enter Password"
        Username.borderStyle = UITextField.BorderStyle.roundedRect
        Username.font = UIFont.systemFont(ofSize: 15)
        Username.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        Username.autocapitalizationType = .none
        Username.isSecureTextEntry = true
        Username.translatesAutoresizingMaskIntoConstraints = false
        return Username
    }()
    
    let PasswordRules: UILabel = {
        let Label = UILabel()
        Label.numberOfLines = 0
        Label.text = "\u{2022} Your password can’t be too similar to your other personal information.\n\u{2022} Your password must contain at least 8 characters.\n\u{2022} Your password can’t be a commonly used password.\n\u{2022} Your password can’t be entirely numeric."
        Label.font = Label.font.withSize(10)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let RetypePasswordLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Retype Password:"
        Label.font = Label.font.withSize(13)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let RetypePassword: UITextField = {
        let Username = UITextField()
        Username.placeholder = "Retype Password"
        Username.borderStyle = UITextField.BorderStyle.roundedRect
        Username.font = UIFont.systemFont(ofSize: 15)
        Username.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        Username.autocapitalizationType = .none
        Username.isSecureTextEntry = true
        Username.translatesAutoresizingMaskIntoConstraints = false
        return Username
    }()
    
    let TotalStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .center
        StackView.spacing = 5
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    let RegisterButton: UIButton = {
        let Button = UIButton()
        Button.setTitle("Create Account", for: .normal)
        Button.backgroundColor = .systemBlue
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.black.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        return Button
    }()
    
    let LoginButton: UIButton = {
        let Button = UIButton()
        Button.setTitle("Login", for: .normal)
        Button.backgroundColor = .systemBlue
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.black.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        return Button
    }()
    
    let StatusLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Status:"
        Label.font = Label.font.withSize(15)
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.lineBreakMode = .byWordWrapping
        Label.numberOfLines = 0
        return Label
    }()
    
    let ActualTotalStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .center
        StackView.spacing = 10
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    func ViewItems() {
        self.addSubview(TotalStackView)
        TotalStackView.addArrangedSubview(UsernameLabel)
        TotalStackView.addArrangedSubview(Username)
        TotalStackView.addArrangedSubview(PasswordLabel)
        TotalStackView.addArrangedSubview(Password)
        TotalStackView.addArrangedSubview(PasswordRules)
        TotalStackView.addArrangedSubview(RetypePasswordLabel)
        TotalStackView.addArrangedSubview(RetypePassword)
        TotalStackView.addArrangedSubview(RegisterButton)
        TotalStackView.addArrangedSubview(StatusLabel)
        setupLayout()
    }
    
    private func setupLayout() {
        TotalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TotalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        Username.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        Username.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        UsernameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        Password.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        Password.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        PasswordLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        PasswordRules.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        RetypePassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        RetypePassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        RetypePasswordLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        RegisterButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true

        RegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        StatusLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        StatusLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
    }
    
}
