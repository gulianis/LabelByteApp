//
//  LoginView.swift
//  LabelByte
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
        Label.text = "LabelByte"
        Label.font = UIFont(name: "Gill Sans", size: 75)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
        
    let LoginLabelInfo: UILabel = {
        let Label = UILabel()
        Label.text = "Enter email and password to log in"
        Label.font = Label.font.withSize(22)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
        
    let EmailInfo: UITextField = {
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
        StackView.spacing = 45
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
    
    let RegisterButtonInfo: UIButton = {
        let Button = UIButton()
        Button.setTitle("Create Account", for: .normal)
        //Button.setTitleColor(.black, for: .normal)
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
        LoginStackView.addArrangedSubview(LoginButtonInfo)
        LoginStackView.addArrangedSubview(RegisterButtonInfo)
        TotalStackView.addArrangedSubview(TitleLabelInfo)
        TotalStackView.addArrangedSubview(LoginStackView)
        self.addSubview(TotalStackView)
        setupLayout()
    }
        
    private func setupLayout() {
        EmailInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        EmailInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        PasswordInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        PasswordInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
            

        LoginButtonInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true

        LoginButtonInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        TotalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TotalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //LinkLabelInfo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //LinkLabelInfo.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        RegisterButtonInfo.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true

        RegisterButtonInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
