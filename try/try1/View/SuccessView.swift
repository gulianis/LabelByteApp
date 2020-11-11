//
//  SuccessView.swift
//  try
//
//  Created by Sandeep Guliani on 9/1/20.
//

import Foundation
import UIKit

class SuccessView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ViewItems()
    }
    
    let Background: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 3.0
        return view
    }()
    
    let Label: UILabel = {
        let Label = UILabel()
        Label.text = ""
        Label.textAlignment = .center
        Label.font = Label.font.withSize(20)
        Label.numberOfLines = 3
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    
    func ViewItems() {
        Background.addSubview(Label)
        self.addSubview(Background)
        setupLayout()
    }
    
    private func setupLayout() {
        Label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        Label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        Background.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        Background.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        Background.heightAnchor.constraint(equalToConstant: 120).isActive = true
        Background.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
}
