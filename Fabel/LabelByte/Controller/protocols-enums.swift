//
//  protocols.swift
//  LabelByte
//
//  Created by Sachin Guliani on 10/29/20.
//

import Foundation

protocol isAbleToReceiveData {
    func pass(data: String)  //data: string is an example parameter
}


protocol LabelOperations {
    
    var delegate: ImageViewController { get set }
    
    var x: Double { get }
    
    var y: Double { get }
    
    func removeShape()
    
    func addClassification(_ text: String)
    
    func getClassification() -> String
    
    func createShape()
    
    func moveShape(_ x: Double, _ y: Double)
    
    func changeShapeSize(_ Ax: Double, _ Ay: Double, _ Bx: Double, _ By: Double)
    
    func intersection(_ x: Double, _ y: Double) -> returnTapped
    
    func makeSelectedColor()
    
    func makeUnSelectedColor()
    
    func makeSpecificColor(_ color: String)
    
    func getDataInStringForm() -> String
    
    func getColor() -> String
}

enum Color {
    case black
    case red
    case green
    case blue
    case orange
    case yellow
    case purple
}

enum TypeOfLabel {
    case boundingBox
    case point
}

enum returnTapped {
    case label
    case shape
    case none
}

enum UnselectedOrSelected {
    case UnSelected
    case Selected
}
