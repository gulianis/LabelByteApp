//
//  LoginView.swift
//  try
//
//  Created by Sachin Guliani on 6/19/20.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ViewItems()
    }
    
    let TitleLabelInfo: UILabel = {
        let Label = UILabel()
        Label.text = "Fabel"
        //Label.textAlignment = .center
        //Label.lineBreakMode = .byWordWrapping
        //Label.textColor = .systemBlue
        //Label.font = Label.font.withSize(75)
        Label.font = UIFont(name: "Gill Sans", size: 75)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let LoginLabelInfo: UILabel = {
        let Label = UILabel()
        Label.text = "Enter email and password to log in"
        //Label.textAlignment = .center
        //Label.lineBreakMode = .byWordWrapping
        Label.font = Label.font.withSize(22)
        //Label.textColor = .systemBlue
        //Label.textColor = .systemBlue
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let EmailInfo: UITextField = {
        //let Email = UITextField (frame: CGRect(x: 10, y: 300, width: 500, height: 40))
        let Email = UITextField()
        Email.placeholder = "Email"
        Email.borderStyle = UITextField.BorderStyle.roundedRect
        Email.font = UIFont.systemFont(ofSize: 15)
        Email.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        Email.autocapitalizationType = .none
        Email.translatesAutoresizingMaskIntoConstraints = false
        return Email
    }()
    
    let PasswordInfo: UITextField = {
        let Password = UITextField(frame: CGRect(x: 50, y: 400, width: 500, height: 40))
        Password.placeholder = "Password"
        Password.borderStyle = UITextField.BorderStyle.roundedRect
        Password.font = UIFont.systemFont(ofSize: 15)
        Password.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        Password.autocapitalizationType = .none
        Password.isSecureTextEntry = true
        Password.translatesAutoresizingMaskIntoConstraints = false
        return Password
    }()
    
    let TextFieldStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .center
        StackView.spacing = 10
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    let LoginStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .center
        StackView.spacing = 15
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    let TotalStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .center
        StackView.spacing = 80
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    let LoginButtonInfo: UIButton = {
        let Button = UIButton()
        Button.setTitle("Log In", for: .normal)
        Button.backgroundColor = .systemBlue
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.black.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        return Button
    }()
    
    func ViewItems() {
        TextFieldStackView.addArrangedSubview(EmailInfo)
        TextFieldStackView.addArrangedSubview(PasswordInfo)
        LoginStackView.addArrangedSubview(LoginLabelInfo)
        LoginStackView.addArrangedSubview(TextFieldStackView)
        //LoginStackView.addArrangedSubview(EmailInfo)
        //LoginStackView.addArrangedSubview(PasswordInfo)
        LoginStackView.addArrangedSubview(LoginButtonInfo)
        TotalStackView.addArrangedSubview(TitleLabelInfo)
        TotalStackView.addArrangedSubview(LoginStackView)
        //TotalStackView.addArrangedSubview(LoginButtonInfo)
        self.addSubview(TotalStackView)
        /*
        self.addSubview(TitleLabelInfo)
        self.addSubview(EmailInfo)
        self.addSubview(PasswordInfo)
        self.addSubview(LoginButtonInfo)
        */
        setupLayout()
    }
    
    private func setupLayout() {
        //LabelInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        /*
        TitleLabelInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TitleLabelInfo.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        
        LoginLabelInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        LoginLabelInfo.topAnchor.constraint(equalTo: TitleLabelInfo.bottomAnchor, constant: 50).isActive = true
        
        EmailInfo.topAnchor.constraint(equalTo: LoginLabelInfo.bottomAnchor, constant: 20).isActive = true
        EmailInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        EmailInfo.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        EmailInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        PasswordInfo.topAnchor.constraint(equalTo: EmailInfo.bottomAnchor, constant: 10).isActive = true
        PasswordInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        PasswordInfo.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        PasswordInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        
        LoginButtonInfo.topAnchor.constraint(equalTo: PasswordInfo.bottomAnchor, constant: 50).isActive = true
        LoginButtonInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        LoginButtonInfo.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        LoginButtonInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        LoginButtonInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        */
        /*
        TitleLabelInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TitleLabelInfo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        EmailInfo.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        EmailInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        EmailInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        PasswordInfo.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        PasswordInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        PasswordInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        LoginButtonInfo.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        LoginButtonInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        LoginButtonInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //TotalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //TotalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        TotalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        TotalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        TotalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        TotalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        //LoginButtonInfo.bottomAnchor.constraint(equalTo:self.safeAreaLayoutGuide.bottomAnchor, constant: -250).isActive = true
        */
        //TitleLabelInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //TitleLabelInfo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        
        //EmailInfo.topAnchor.constraint(equalTo: TitleLabelInfo.bottomAnchor, constant: 20).isActive = true
        //EmailInfo.topAnchor.constraint(equalTo: TitleLabelInfo.bottomAnchor, constant: 50).isActive = true
        //EmailInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        EmailInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        //EmailInfo.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        
        //EmailInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //PasswordInfo.topAnchor.constraint(equalTo: EmailInfo.bottomAnchor, constant: 10).isActive = true
        //PasswordInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        PasswordInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        //PasswordInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        PasswordInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //LoginButtonInfo.topAnchor.constraint(equalTo: PasswordInfo.bottomAnchor, constant: 20).isActive = true
        LoginButtonInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        //LoginButtonInfo.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        LoginButtonInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        TotalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TotalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
