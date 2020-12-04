//
//  BoudingBoxFunctions.swift
//  try
//
//  Created by Sachin Guliani on 8/11/20.
//

import UIKit
import Foundation

class BoundingBoxLabel: LabelOperations {
    
    var x: Double
    var y: Double
    var w: Double
    var h: Double
    var shape: UIView
    var label = UILabel()
    var labelBackground = UIView()
    var labelSize: Double = 40
    var labelBorderWidth: Double = 4
    var classification = ""
    var prevh: Double
    unowned var delegate: ImageViewController
    var currentUnSelectedColor: CGColor?
    var largeImage: UIImageView
    
    init(x: Double, y: Double, w: Double = 100, h: Double = 100, delegate: ImageViewController) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.shape = UIView()
        self.prevh = 0
        self.delegate = delegate
        self.currentUnSelectedColor = nil
        self.largeImage = delegate.largeImage
    }
    
    func createShape() {
        // Sets up Bounding Box and Classification Label
        self.shape.frame = CGRect(x: x, y: y, width: self.w, height: self.h)
        self.shape.layer.borderWidth = 4.0
        largeImage.addSubview(self.shape)
        let size = labelSize + labelBorderWidth
        label.frame = CGRect(x: x, y: y - labelSize, width: size, height: size)
        labelBackground.frame = CGRect(x: x, y: y - labelSize, width: size, height: size)
        labelBackground.backgroundColor = .gray
        label.font = UIFont(name: "Arial", size: 24)
        label.textColor = .white
        addClassification("")
        labelBackground.layer.borderWidth = CGFloat(labelBorderWidth)
        largeImage.addSubview(labelBackground)
        largeImage.addSubview(label)
        makeUnSelectedColor()
    }
    
    func addClassification(_ text: String) {
        // adds Classification and makes label text formatted
        classification = text
        if text.count > 0 {
            label.text = " " + text + " "
        } else {
            label.text = "  +  "
        }
        labelBackground.frame.size.width = label.intrinsicContentSize.width
        label.frame.size.width = label.intrinsicContentSize.width
    }
    
    func getClassification() -> String {
        // Classification without formatting
        return classification
    }
    
    func removeShape() {
        // removes bounding box from view
        self.shape.removeFromSuperview()
        label.removeFromSuperview()
        labelBackground.removeFromSuperview()
    }
    
    func intersection(_ x: Double, _ y: Double) -> returnTapped {
        // detects where label tapped
        let minX = self.x
        let maxX = self.x + self.w
        let minY = self.y
        let maxY = self.y + self.h
        if x >= minX && x <= maxX && y >= minY && y <= maxY {
            return .shape
        }
        let minXLabel = self.x
        let maxXLabel = self.x + Double(label.intrinsicContentSize.width)
        let minYLabel = self.y - labelSize
        let maxYLabel = self.y
        if x >= minXLabel && x <= maxXLabel && y >= minYLabel && y <= maxYLabel {
            return .label
        }
        return .none
    }
    
    func moveShape(_ x: Double, _ y: Double) {
        // puts label at new coordinate
        UIView.animate(withDuration: 0.1) {
            self.x = x
            self.y = y
            self.shape.frame.origin.x = CGFloat(x)
            self.shape.frame.origin.y = CGFloat(y)
            self.label.frame.origin.x = CGFloat(x)
            self.label.frame.origin.y = CGFloat(y) - CGFloat(self.labelSize)
            self.labelBackground.frame.origin.x = CGFloat(x)
            self.labelBackground.frame.origin.y = CGFloat(y) - CGFloat(self.labelSize)
        }
    }
    
    func changeShapeSize(_ Ax: Double, _ Ay: Double, _ Bx: Double, _ By: Double) {
        // Changes shape size based on pinching
        let center_x = (Ax + Bx)/2
        let center_y = (Ay + By)/2
        let h = pow(pow(center_x - Ax, 2) + pow(center_y - Ay, 2), 0.5)
        let cos_x = abs((Ax-center_x)/h)
        let sin_y = abs((Ay-center_y)/h)
        if h > prevh {
            UIView.animate(withDuration: 0.1) {
                self.shape.frame.size.width += 5*CGFloat(cos_x)
                self.shape.frame.size.height += 5*CGFloat(sin_y)
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                if self.shape.frame.size.width > 10 {
                    self.shape.frame.size.width -= 5*CGFloat(cos_x)
                }
                if self.shape.frame.size.height > 10 {
                    self.shape.frame.size.height -= 5*CGFloat(sin_y)
                }
            }
        }
        self.w = Double(self.shape.frame.size.width)
        self.h = Double(self.shape.frame.size.height)
        prevh = h
    }
    
    func makeSelectedColor() {
        // Changes label color based on selected color attribute
        currentUnSelectedColor = self.shape.layer.borderColor
        // Saves Unselected Color
        switch (SelectedColor) {
            case .black:
                self.shape.layer.borderColor = UIColor.black.cgColor
                labelBackground.layer.borderColor = UIColor.black.cgColor
            case .red:
                self.shape.layer.borderColor = UIColor.red.cgColor
                labelBackground.layer.borderColor = UIColor.red.cgColor
            case .green:
                self.shape.layer.borderColor = UIColor.green.cgColor
                labelBackground.layer.borderColor = UIColor.green.cgColor
            case .blue:
                self.shape.layer.borderColor = UIColor.blue.cgColor
                labelBackground.layer.borderColor = UIColor.blue.cgColor
            case .orange:
                self.shape.layer.borderColor = UIColor.orange.cgColor
                labelBackground.layer.borderColor = UIColor.orange.cgColor
            case .purple:
                self.shape.layer.borderColor = UIColor.purple.cgColor
                labelBackground.layer.borderColor = UIColor.purple.cgColor
            default:
                self.shape.layer.borderColor = UIColor.yellow.cgColor
                labelBackground.layer.borderColor = UIColor.yellow.cgColor
        }
    }
    
    func makeUnSelectedColor() {
        // Changes label color based on unselected color attribute
        if currentUnSelectedColor == nil {
            switch (UnSelectedColor) {
                case .black:
                    self.shape.layer.borderColor = UIColor.black.cgColor
                    labelBackground.layer.borderColor = UIColor.black.cgColor
                case .red:
                    self.shape.layer.borderColor = UIColor.red.cgColor
                    labelBackground.layer.borderColor = UIColor.red.cgColor
                case .green:
                    self.shape.layer.borderColor = UIColor.green.cgColor
                    labelBackground.layer.borderColor = UIColor.green.cgColor
                case .blue:
                    self.shape.layer.borderColor = UIColor.blue.cgColor
                    labelBackground.layer.borderColor = UIColor.blue.cgColor
                case .orange:
                    self.shape.layer.borderColor = UIColor.orange.cgColor
                    labelBackground.layer.borderColor = UIColor.orange.cgColor
                case .purple:
                    self.shape.layer.borderColor = UIColor.purple.cgColor
                    labelBackground.layer.borderColor = UIColor.purple.cgColor
                default:
                    self.shape.layer.borderColor = UIColor.yellow.cgColor
                    labelBackground.layer.borderColor = UIColor.yellow.cgColor
            }
        } else {
            self.shape.layer.borderColor = currentUnSelectedColor
            labelBackground.layer.borderColor = currentUnSelectedColor
        }
    }
    
    func makeSpecificColor(_ color: String) {
        // make label a color
        switch (color) {
            case "black":
                self.shape.layer.borderColor = UIColor.black.cgColor
                labelBackground.layer.borderColor = UIColor.black.cgColor
            case "red":
                self.shape.layer.borderColor = UIColor.red.cgColor
                labelBackground.layer.borderColor = UIColor.red.cgColor
            case "green":
                self.shape.layer.borderColor = UIColor.green.cgColor
                labelBackground.layer.borderColor = UIColor.green.cgColor
            case "blue":
                self.shape.layer.borderColor = UIColor.blue.cgColor
                labelBackground.layer.borderColor = UIColor.blue.cgColor
            case "orange":
                self.shape.layer.borderColor = UIColor.orange.cgColor
                labelBackground.layer.borderColor = UIColor.orange.cgColor
            case "purple":
                self.shape.layer.borderColor = UIColor.purple.cgColor
                labelBackground.layer.borderColor = UIColor.purple.cgColor
            default:
                self.shape.layer.borderColor = UIColor.yellow.cgColor
                labelBackground.layer.borderColor = UIColor.yellow.cgColor
        }
    }
    
    func getDataInStringForm() -> String {
        // Put label data in human readable format
        let rounded_x = roundToThreeDecimalPlaces(x)
        let rounded_y = roundToThreeDecimalPlaces(y)
        let rounded_w = roundToThreeDecimalPlaces(w)
        let rounded_h = roundToThreeDecimalPlaces(h)
        return "(\(rounded_x),\(rounded_y),\(rounded_w),\(rounded_h))"
    }
    
    func getColor() -> String {
        // Get color of Label
        switch (self.shape.layer.borderColor) {
            case UIColor.black.cgColor:
                return "black"
            case UIColor.red.cgColor:
                return "red"
            case UIColor.green.cgColor:
                return "green"
            case UIColor.blue.cgColor:
                return "blue"
            case UIColor.orange.cgColor:
                return "orange"
            case UIColor.purple.cgColor:
                return "purple"
            default:
                return "yellow"
        }
    }
}

class PointLabel: LabelOperations {

    var x: Double
    var y: Double
    var dimension: Double
    var shape: UIImageView
    var prevh: Double
    unowned var delegate: ImageViewController
    var currentUnSelectedColor: UIColor?
    var largeImage: UIImageView
    
    init(x: Double, y: Double, dimension: Double, delegate: ImageViewController) {
        self.x = x
        self.y = y
        self.dimension = dimension
        self.shape = UIImageView()
        self.prevh = 0
        self.delegate = delegate
        self.currentUnSelectedColor = nil
        self.largeImage = delegate.largeImage
    }
    
    func createShape() {
        // Sets up Point Label
        // Have to deal with sizing UIGraphicsImageRenderer object
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)

            let rectangle = CGRect(x: 1, y: 1, width: 18, height: 18)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        let Show = UIImageView(image: img)
        Show.frame.origin.x = CGFloat(self.x) - CGFloat(self.dimension/2)
        Show.frame.origin.y = CGFloat(self.y) - CGFloat(self.dimension/2)
        Show.frame.size.width = CGFloat(self.dimension)
        Show.frame.size.height = CGFloat(self.dimension)
        self.shape = Show
        largeImage.addSubview(self.shape)
        makeUnSelectedColor()
        
    }
    
    func addClassification(_ text: String) {
        // Not Used, added to conform with protocol
    }
    
    func getClassification() -> String {
        // Not Used, added to conform with protocol
        return ""
    }
    
    func removeShape() {
        // Remove Point Label from view
        self.shape.removeFromSuperview()
    }
    
    func intersection(_ x: Double, _ y: Double) -> returnTapped {
        // Check if Point Label is tapped
        if pow(pow((x - self.x),2) + pow((y - self.y),2), 0.5) <= self.dimension/2 {
            return .shape
        }
        return .none
    }
    
    func moveShape(_ x: Double, _ y: Double) {
        // Move Label to specific coordinate
        self.shape.frame.origin.x = CGFloat(x) - CGFloat(self.dimension/2)
        self.shape.frame.origin.y = CGFloat(y) - CGFloat(self.dimension/2)
        self.x = Double(x)
        self.y = Double(y)
    }
    
    func changeShapeSize(_ Ax: Double, _ Ay: Double, _ Bx: Double, _ By: Double) {
        // Change shape based on pinching
        let center_x = (Ax + Bx)/2
        let center_y = (Ay + By)/2
        let h = pow(pow(center_x - Ax, 2) + pow(center_y - Ay, 2), 0.5)
        let change = CGFloat(2)
        if h > self.prevh {
            UIView.animate(withDuration: 0.1) {
                if self.shape.frame.size.width < 50 {
                    self.shape.frame.size.width += change
                    self.shape.frame.size.height += change
                    self.shape.frame.origin.x -= change/2
                    self.shape.frame.origin.y -= change/2
                }
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                if self.shape.frame.size.width > 5 {
                    self.shape.frame.size.width -= change
                    self.shape.frame.size.height -= change
                    self.shape.frame.origin.x += change/2
                    self.shape.frame.origin.y += change/2
                }
            }
        }
        self.dimension = 2*(self.x - Double(self.shape.frame.origin.x))
        self.delegate.updateDimension(self.dimension)
        // dimension in ImageViewController needs to be updated so new Point Labels
        // can have the same size
        self.prevh = h
    }
    
    func makeSelectedColor() {
        // makes UIImageGraphics object Selected Color
        currentUnSelectedColor = self.shape.tintColor
        self.shape.image = self.shape.image?.withRenderingMode(.alwaysTemplate)
        self.shape.tintColor = ColorLabelToUIColor[SelectedColor]
    }
    
    func makeUnSelectedColor() {
        // makes UIImageGraphics object UnSelected Color
        if currentUnSelectedColor == nil {
            self.shape.image = self.shape.image?.withRenderingMode(.alwaysTemplate)
            self.shape.tintColor = ColorLabelToUIColor[UnSelectedColor]
        } else {
            self.shape.tintColor = currentUnSelectedColor
        }
    }
    
    func makeSpecificColor(_ color: String) {
        // makes UIImageGraphics object a specific Color
        self.shape.image = self.shape.image?.withRenderingMode(.alwaysTemplate)
        switch (color) {
            case "black":
                self.shape.tintColor = .black
            case "red":
                self.shape.tintColor = .red
            case "green":
                self.shape.tintColor = .green
            case "blue":
                self.shape.tintColor = .blue
            case "orange":
                self.shape.tintColor = .orange
            case "purple":
                self.shape.tintColor = .purple
            default:
                self.shape.tintColor = .yellow
        }
    }
    
    func getDataInStringForm() -> String {
        // Put Label data in human readable form
        let rounded_x = roundToThreeDecimalPlaces(x)
        let rounded_y = roundToThreeDecimalPlaces(y)
        let rounded_dimension = roundToThreeDecimalPlaces(self.dimension)
        return "(\(rounded_x),\(rounded_y),\(rounded_dimension))"
    }
    
    func getColor() -> String {
        // get color of Point Label
        switch (self.shape.tintColor) {
            case UIColor.black:
                return "black"
            case UIColor.red:
                return "red"
            case UIColor.green:
                return "green"
            case UIColor.blue:
                return "blue"
            case UIColor.orange:
                return "orange"
            case UIColor.purple:
                return "purple"
            default:
                return "yellow"
        }
    }
    
}

func roundToThreeDecimalPlaces(_ number: Double) -> Double {
    return (number * 1000).rounded() / 1000
}
