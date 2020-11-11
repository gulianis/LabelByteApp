//
//  ViewFunctions.swift
//  try
//
//  Created by Sandeep Guliani on 8/16/20.
//


import Foundation
import UIKit

func createColorButton(_ color: String) -> UIButton {
    let Button = UIButton()
    Button.backgroundColor = .white
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.black.cgColor
    Button.layer.borderWidth = 1
    Button.translatesAutoresizingMaskIntoConstraints = false
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
    let img = renderer.image { ctx in
        switch (color) {
            case "black":
                ctx.cgContext.setFillColor(UIColor.black.cgColor)
            case "red":
                ctx.cgContext.setFillColor(UIColor.red.cgColor)
            case "green":
                ctx.cgContext.setFillColor(UIColor.green.cgColor)
            case "blue":
                ctx.cgContext.setFillColor(UIColor.blue.cgColor)
            case "orange":
                ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            case "purple":
                ctx.cgContext.setFillColor(UIColor.purple.cgColor)
            default:
                ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
        }
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(1)

        let rectangle = CGRect(x: 4, y: 4, width: 32, height: 32)
        ctx.cgContext.addRect(rectangle)
        ctx.cgContext.drawPath(using: .fillStroke)
    }
    Button.setImage(img, for: .normal)
    return Button
}
