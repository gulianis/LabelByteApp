//
//  View.swift
//  try
//
//  Created by Sachin Guliani on 3/29/20.
//

import Foundation
import UIKit

let scrollView: UIScrollView = {
    let scrollView = UIScrollView()

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
}()

let largeImage: UIImageView = {
    let ImageView = UIImageView()
    //let image: UIImage = UIImage(named: "very_large_photo")!
    //ImageView.image = image
    ImageView.translatesAutoresizingMaskIntoConstraints = false
    return ImageView
}()

let LabelInfo: UILabel = {
    let Label = UILabel()
    Label.text = "Apply Bounding Box to Cars"
    //Label.textAlignment = .center
    //Label.lineBreakMode = .byWordWrapping
    Label.font = Label.font.withSize(32)
    Label.numberOfLines = 3
    Label.translatesAutoresizingMaskIntoConstraints = false
    return Label
}()

let ButtonInfo: UIButton = {
    let Button = UIButton()
    Button.setTitle("Save", for: .normal)
    Button.backgroundColor = .systemBlue
    Button.translatesAutoresizingMaskIntoConstraints = false
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.black.cgColor
    Button.layer.borderWidth = 3
    return Button
}()

let ToolBoxStackView: UIStackView = {
    return createToolBox()
}()

let ToolBoxVerticalStackView: UIStackView = {
    return createVerticalToolBox()
}()

let ScrollViewPlusToolBoxStackView: UIStackView = {
    let StackView = UIStackView()
    StackView.axis = .horizontal
    StackView.distribution = .fillEqually
    StackView.alignment = .center
    StackView.spacing = 10
    StackView.translatesAutoresizingMaskIntoConstraints = false
    return StackView
}()

let blackButton: UIButton = {
    let button = createColorButton("black")
    return button
}()
   
let redButton: UIButton = {
    let button = createColorButton("red")
    return button
}()
   
let greenButton: UIButton = {
    let button = createColorButton("green")
    return button
}()
   
let blueButton: UIButton = {
    let button = createColorButton("blue")
    return button
}()
   
let orangeButton: UIButton = {
    let button = createColorButton("orange")
    return button
}()
   
let purpleButton: UIButton = {
    let button = createColorButton("purple")
    return button
}()
   
let yellowButton: UIButton = {
    let button = createColorButton("yellow")
    return button
}()
   
let ColorPickerStackView: UIStackView = {
    let ButtonStackView = UIStackView()
    ButtonStackView.axis = .horizontal
    ButtonStackView.distribution = .fillEqually
    ButtonStackView.alignment = .center
    ButtonStackView.spacing = 5
    ButtonStackView.translatesAutoresizingMaskIntoConstraints = false
    ButtonStackView.isHidden = true
    return ButtonStackView
}()
   
let TotalStackViewBackground: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 10.0
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 3.0
    return view
}()

let ConnectorView: UIView = {
    let view = UIView()
    view.backgroundColor = .green
    view.layer.cornerRadius = 10.0
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 10.0
    return view
}()

