//
//  UploadView.swift
//  LabelByte
//
//  Created by Sandeep Guliani on 1/6/21.
//

import Foundation
import UIKit

class UploadView {
    
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
        Label.numberOfLines = 0
        Label.text = "Steps:\n1. Click on Files app\n2. Place images you would\n    like to label in a folder\n3. Compress folder into a\n    zip file\n4. Select and upload zip file"
        //Label.textAlignment = .center
        Label.font = Label.font.withSize(17)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let Select: UIButton = {
        let Select = UIButton()
        Select.setTitle("Select", for: .normal)
        Select.backgroundColor = .systemBlue
        Select.translatesAutoresizingMaskIntoConstraints = false
        Select.layer.cornerRadius = 5
        Select.layer.borderColor = UIColor.black.cgColor
        Select.layer.borderWidth = 3
        return Select
    }()
    
    let FileName: UILabel = {
        let Label = UILabel()
        Label.text = "None Selected"
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let Upload: UIButton = {
        let Upload = UIButton()
        Upload.setTitle("Upload", for: .normal)
        Upload.backgroundColor = .systemBlue
        Upload.translatesAutoresizingMaskIntoConstraints = false
        Upload.layer.cornerRadius = 5
        Upload.layer.borderColor = UIColor.black.cgColor
        Upload.layer.borderWidth = 3
        return Upload
    }()

    let HorizontalStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .horizontal
        StackView.distribution = .fillEqually
        StackView.alignment = .center
        StackView.spacing = 10
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    let Status: UILabel = {
        let Label = UILabel()
        Label.text = "Status:"
        Label.numberOfLines = 0
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    let Note: UILabel = {
        let Label = UILabel()
        Label.text = "*You can also upload files on \n labelbyte.com\n*Uploaded file will delete after 7 days"
        Label.numberOfLines = 0
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.font = Label.font.withSize(12)
        return Label
    }()
    
}
