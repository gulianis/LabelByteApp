//
//  ToolBoxView.swift
//  try
//
//  Created by Sachin Guliani on 8/21/20.
//

import Foundation
import UIKit

/*
let BoundingBoxButton: UIButton = {
    let Button = UIButton()
    Button.backgroundColor = .lightGray
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.darkGray.cgColor
    Button.layer.borderWidth = 3
    Button.translatesAutoresizingMaskIntoConstraints = false
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
    let img = renderer.image { ctx in
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(3)

        let rectangle = CGRect(x: 10, y: 10, width: 30, height: 30)
        ctx.cgContext.addRect(rectangle)
        ctx.cgContext.drawPath(using: .stroke)
    }
    Button.setImage(img, for: .normal)
    return Button
}()

let PointButton: UIButton = {
    let Button = UIButton()
    Button.backgroundColor = .white
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.darkGray.cgColor
    Button.layer.borderWidth = 3
    Button.translatesAutoresizingMaskIntoConstraints = false
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
    let img = renderer.image { ctx in
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(1)

        let rectangle = CGRect(x: 10, y: 10, width: 30, height: 30)
        ctx.cgContext.addEllipse(in: rectangle)
        ctx.cgContext.drawPath(using: .fillStroke)
    }
    Button.setImage(img, for: .normal)
    return Button
}()

let UnSelectedColorButton: UIButton = {
    let Button = UIButton()
    Button.backgroundColor = .white
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.darkGray.cgColor
    Button.layer.borderWidth = 3
    Button.translatesAutoresizingMaskIntoConstraints = false
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
    let img = renderer.image { ctx in
        ctx.cgContext.setFillColor(UIColor.black.cgColor)
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(0)

        let rectangle = CGRect(x: 3, y: 3, width: 44, height: 44)
        ctx.cgContext.addRect(rectangle)
        ctx.cgContext.drawPath(using: .fillStroke)
    }
    Button.setTitle("DES", for: .normal)
    Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
    Button.setTitleColor(.white, for: .normal)
    Button.setBackgroundImage(img.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    Button.tintColor = .black
    return Button
}()

unowned var SelectedColorButton: UIButton = {
    let Button = UIButton()
    Button.backgroundColor = .white
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.darkGray.cgColor
    Button.layer.borderWidth = 3
    Button.translatesAutoresizingMaskIntoConstraints = false
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
    let img = renderer.image { ctx in
        ctx.cgContext.setFillColor(UIColor.black.cgColor)
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(0)

        let rectangle = CGRect(x: 3, y: 3, width: 44, height: 44)
        ctx.cgContext.addRect(rectangle)
        ctx.cgContext.drawPath(using: .fillStroke)
    }
    Button.setTitle("SEL", for: .normal)
    Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
    Button.setTitleColor(.white, for: .normal)
    Button.setBackgroundImage(img.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    Button.tintColor = .red
    return Button
}()

let DeleteButton: UIButton = {
    let Button = UIButton()
    Button.backgroundColor = .white
    Button.layer.cornerRadius = 5
    Button.layer.borderColor = UIColor.darkGray.cgColor
    Button.layer.borderWidth = 3
    Button.translatesAutoresizingMaskIntoConstraints = false
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
    let img = renderer.image { ctx in
        ctx.cgContext.setFillColor(UIColor.black.cgColor)
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(0)

        let rectangle = CGRect(x: 3, y: 3, width: 44, height: 44)
        ctx.cgContext.addRect(rectangle)
        ctx.cgContext.drawPath(using: .fillStroke)
    }
    Button.setTitle("DEL", for: .normal)
    Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
    Button.setTitleColor(.black, for: .normal)
    Button.setBackgroundImage(img.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    Button.tintColor = .white
    return Button
}()

let ToolStackView: UIStackView = {
    let StackView = UIStackView()
    StackView.axis = .horizontal
    StackView.distribution = .fillEqually
    StackView.alignment = .center
    StackView.spacing = 0
    StackView.translatesAutoresizingMaskIntoConstraints = false
    return StackView
}()

let ToolVerticalStackView: UIStackView = {
    let StackView = UIStackView()
    StackView.axis = .vertical
    StackView.distribution = .fillEqually
    StackView.alignment = .center
    StackView.spacing = 0
    StackView.translatesAutoresizingMaskIntoConstraints = false
    return StackView
}()

func createToolBox() -> UIStackView {
    ToolStackView.addArrangedSubview(BoundingBoxButton)
    ToolStackView.addArrangedSubview(PointButton)
    ToolStackView.addArrangedSubview(UnSelectedColorButton)
    ToolStackView.addArrangedSubview(SelectedColorButton)
    ToolStackView.addArrangedSubview(DeleteButton)
    return ToolStackView
}

func createVerticalToolBox() -> UIStackView {
    ToolVerticalStackView.addArrangedSubview(BoundingBoxButton)
    ToolVerticalStackView.addArrangedSubview(PointButton)
    ToolVerticalStackView.addArrangedSubview(UnSelectedColorButton)
    ToolVerticalStackView.addArrangedSubview(SelectedColorButton)
    ToolVerticalStackView.addArrangedSubview(DeleteButton)
    return ToolVerticalStackView
}
*/

class ToolBoxFunction {
    
    deinit {
        //clearCache()
        print("ToolBoxView is deinitialized")
    }
    
    let BoundingBoxButton: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .lightGray
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.darkGray.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let img = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(3)

            let rectangle = CGRect(x: 10, y: 10, width: 30, height: 30)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .stroke)
        }
        Button.setImage(img, for: .normal)
        return Button
    }()

    let PointButton: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .white
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.darkGray.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let img = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)

            let rectangle = CGRect(x: 10, y: 10, width: 30, height: 30)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        Button.setImage(img, for: .normal)
        return Button
    }()

    let UnSelectedColorButton: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .white
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.darkGray.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(0)

            let rectangle = CGRect(x: 3, y: 3, width: 44, height: 44)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        Button.setTitle("DES", for: .normal)
        Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        Button.setTitleColor(.white, for: .normal)
        Button.setBackgroundImage(img.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        Button.tintColor = .black
        return Button
    }()

    let SelectedColorButton: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .white
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.darkGray.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(0)

            let rectangle = CGRect(x: 3, y: 3, width: 44, height: 44)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        Button.setTitle("SEL", for: .normal)
        Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        Button.setTitleColor(.white, for: .normal)
        Button.setBackgroundImage(img.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        Button.tintColor = .red
        return Button
    }()

    let DeleteButton: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .white
        Button.layer.cornerRadius = 5
        Button.layer.borderColor = UIColor.darkGray.cgColor
        Button.layer.borderWidth = 3
        Button.translatesAutoresizingMaskIntoConstraints = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(0)

            let rectangle = CGRect(x: 3, y: 3, width: 44, height: 44)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        Button.setTitle("DEL", for: .normal)
        Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        Button.setTitleColor(.black, for: .normal)
        Button.setBackgroundImage(img.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        Button.tintColor = .white
        return Button
    }()

    let ToolStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .horizontal
        StackView.distribution = .fillEqually
        StackView.alignment = .center
        StackView.spacing = 0
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()

    let ToolVerticalStackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fillEqually
        StackView.alignment = .center
        StackView.spacing = 0
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    /*

    func createToolBox() -> UIStackView {
        ToolStackView.addArrangedSubview(BoundingBoxButton)
        ToolStackView.addArrangedSubview(PointButton)
        ToolStackView.addArrangedSubview(UnSelectedColorButton)
        ToolStackView.addArrangedSubview(SelectedColorButton)
        ToolStackView.addArrangedSubview(DeleteButton)
        return ToolStackView
    }

    func createVerticalToolBox() -> UIStackView {
        ToolVerticalStackView.addArrangedSubview(BoundingBoxButton)
        ToolVerticalStackView.addArrangedSubview(PointButton)
        ToolVerticalStackView.addArrangedSubview(UnSelectedColorButton)
        ToolVerticalStackView.addArrangedSubview(SelectedColorButton)
        ToolVerticalStackView.addArrangedSubview(DeleteButton)
        return ToolVerticalStackView
    }
    */
}

