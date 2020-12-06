//
//  PopUpView.swift
//  try
//
//  Created by Sachin Guliani on 6/30/20.
//

import Foundation
import UIKit

func addTitleAndBulletPoints(_ title: String, _ bulletString: [String]) -> String {
    // formats title and string list to a list with a title
    // and bulleted strings
    var labelString = "  " + title + "\n"
    
    for string1: String in bulletString {
        let bulletPoint: String = " \u{2022}"
        let start = string1.index(string1.startIndex, offsetBy: 0)
        let end = string1.index(string1.startIndex, offsetBy: 5)
        var formattedString: String = ""
        // If (next) in string put it on next line without bullet
        if string1[start...end] == "(next)" {
            let newStart = string1.index(string1.startIndex, offsetBy: 6)
            let newEnd = string1.index(string1.endIndex, offsetBy: -1)
            formattedString += "    \(string1[newStart...newEnd]) \n"
        } else {
            formattedString += "  \(bulletPoint) \(string1) \n"
        }
        labelString += formattedString
    }
    
    return labelString
}

class InstructionsView {

    // Each list has a horizontal and vertical version

    let instructionsLabel1Vertical: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        var title = ""
        var bullet = [String]()
        title = "     ToolBox Contains: "
        bullet = ["  Bounding Box Label  ", "  Point Label  ", "  Label Color  ", "  Selected Label Color  ", "  Delete Label  "]
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        
        return label
    }()

    let instructionsLabel1Horizontal: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        var title = ""
        var bullet = [String]()
        title = "     ToolBox Contains: "
        bullet = ["  Bounding Box Label  ", "  Point Label  ", "  Label Color  ", "  Selected Label Color  ", "  Delete Label  "]
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        
        return label
    }()

    let instructionsLabel2Vertical: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        var title = ""
        var bullet = [String]()
        
        title = "     Operations:  "
        bullet = ["  Drag finger to Scroll  ", "  Tap Screen to Place Label  ", "  Tap + on Bounding Box ", "(next)    to add Classification "]
        
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        label.isHidden = true
        
        return label
    }()

    let instructionsLabel2Horizontal: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        var title = ""
        var bullet = [String]()
        
        title = "     Operations:  "
        bullet = ["  Drag finger to  ", "(next)    Scroll","  Tap Screen to ", "(next)    Place Label  ", "  Tap + on ", "(next)    Bounding Box to ", "(next)    add Classification  "]
        
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        label.isHidden = true
        
        return label
    }()

    let instructionsLabel3Vertical: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let title = "     How to Select:  "
        let bullet = ["  Tap on Label or Inside Label","  (Selection Box) -  Hold Down  " , "(next)    Finger and Drag  around Label  "]
        
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        
        return label
    }()

    let instructionsLabel3Horizontal: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let title = "      How to Select:  "
        let bullet = ["  Tap on Label  ", "(next)    or Inside Label","  (Selection Box) -  ",
                      "(next)    Hold Down  " , "(next)    Finger and Drag  ", "(next)    around Label  "]
        
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        
        return label
    }()

    let instructionsLabel4Vertical: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let title = "      Selected Operations:  "
        let bullet = ["  Use Pinch Gesture to Shrink ", "(next)    Label", "  Use Expand Gesture to Grow ", "(next)    Label", "  Hold and Drag to Move Label  ", "  Tap Inside to Delete Label  ", "  Tap Outside to Deselect Label  "]
        
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        
        return label
    }()

    let instructionsLabel4Horizontal: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let title = "      Selected Operations:  "
        let bullet = ["  Use Pinch Gesture ", "(next)    to Shrink Label  ", "  Use Expand Gesture ", "(next)    to Grow Label  ", "  Hold and Drag to ", "(next)    Move Label  ", "  Tap Inside to ",
                      "(next)    Delete Label  ", "  Tap Outside to ", "(next)    Deselect Label  "]
        
        label.text = addTitleAndBulletPoints(title, bullet)
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        
        return label
    }()

    let instructionsLabelStackView: UIStackView = {
        let LabelStackView = UIStackView()
        LabelStackView.axis = .vertical
        LabelStackView.distribution = .fill
        LabelStackView.alignment = .center
        LabelStackView.spacing = 0
        LabelStackView.translatesAutoresizingMaskIntoConstraints = false
        return LabelStackView
    }()
    
}
