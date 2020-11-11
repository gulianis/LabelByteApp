//
//  TextFieldPopUpView.swift
//  try
//
//  Created by Sandeep Guliani on 8/9/20.
//


import Foundation
import UIKit


class TextFieldPopUpView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ViewItems()
    }
    
    let TextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Add Classification"
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.font = UIFont.systemFont(ofSize: 15)
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.autocapitalizationType = .none
        textfield.isUserInteractionEnabled = true
        textfield.textAlignment = .center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    func ViewItems() {
        self.addSubview(TextField)
        setupLayout()
    }
    
    private func setupLayout() {
        //TextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 400).isActive = true
        TextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //TextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        //TextField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        TextField.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        TextField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        TextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
