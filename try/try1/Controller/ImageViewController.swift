//
//  ImageViewController.swift
//  try
//
//  Created by Sandeep Guliani on 8/12/20.
//

import UIKit
import CoreData


var ColorLabelToUIColor: [Color: UIColor] = [.black:UIColor.black, .red:UIColor.red, .green:UIColor.green, .blue:UIColor.blue, .orange:UIColor.orange, .purple:UIColor.purple, .yellow:UIColor.yellow]

var UnSelectedColor: Color = .black
var SelectedColor: Color = .red

var CurrentLabelType: TypeOfLabel = .boundingBox
//var UnSelectedColor: Color = .black
//var SelectedColor: Color = .red

var CurrentColorButtonSelected: UIButton?
var SelectedOrUnSelectedButton: UnselectedOrSelected = .UnSelected

class ImageViewController: UIViewController, UIScrollViewDelegate, receiveDataFromLabelMenu, isAbleToReceiveData {
    
    var labelObjects = [LabelOperations]()
    
    var imageData: Data?
       
    var redItem: Int? = nil

    var dimension = Double(15)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getImage() {
        var image: UIImage? = UIImage()
        let semaphore = DispatchSemaphore(value: 0)
        ReceiveImage(imageData!.ofZipFile!.name!, imageData!.name!) { output in
            image = output
            semaphore.signal()
        }
        semaphore.wait()
        if image != nil {
            largeImage.image = image
        } else {
            largeImage.image = UIImage()
        }
        
    }
    
    func CallSendCoordinates(_ data: [String: String]) {
        var result = ""
        let semaphore = DispatchSemaphore(value: 0)
        SendCoordinates(data) { output in
            result = output
            semaphore.signal()
        }
        semaphore.wait()
        self.definesPresentationContext = true
        let vc = SuccessViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.message = result
        present(vc, animated: true, completion: nil)
    }
       
    func getCoordinates() {
        var DictString = ""
        let semaphore = DispatchSemaphore(value: 0)
        GETCoordinates(imageData!.ofZipFile!.name!, imageData!.name!) { output in
            DictString = output
            print("abc")
            print(DictString)
            print("def")
            semaphore.signal()
        }
        semaphore.wait()
        let jsonData = DictString.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        print(dictionary)
        if let Data = dictionary as? [String: String] {
            var count = Int(Data["BoundingBox_count"]!)
            var i = 0
            while i < count! {
                let Data_i = Data["BoundingBox_\(i)_data"]
                let Data_i_color = Data["BoundingBox_\(i)_color"]
                let Data_i_classification = Data["BoundingBox_\(i)_classification"]
                let Data_i_arr = Data_i!.components(separatedBy: ",")
                let x = Double(Data_i_arr[0].dropFirst())!
                let y = Double(Data_i_arr[1])!
                let w = Double(Data_i_arr[2])!
                let h = Double(Data_i_arr[3].dropLast())!
                let newBoundingBoxLabel = BoundingBoxLabel(x: x, y: y, w: w, h: h, delegate: self)
                newBoundingBoxLabel.createShape()
                newBoundingBoxLabel.makeSpecificColor(Data_i_color!)
                newBoundingBoxLabel.addClassification(Data_i_classification!)
                labelObjects.append(newBoundingBoxLabel)
                i += 1
                
            }
            count = Int(Data["Point_count"]!)
            i = 0
            while i < count! {
                let Data_i = Data["Point_\(i)_data"]
                let Data_i_color = Data["Point_\(i)_color"]
                let Data_i_classification = Data["Point_\(i)_classification"]
                let Data_i_arr = Data_i!.components(separatedBy: ",")
                let x = Double(Data_i_arr[0].dropFirst())!
                let y = Double(Data_i_arr[1])!
                let newDimension = Double(Data_i_arr[2].dropLast())!
                dimension = Double(newDimension)
                let newPointLabel = PointLabel(x: x, y: y, dimension: newDimension, delegate: self)
                newPointLabel.createShape()
                newPointLabel.makeSpecificColor(Data_i_color!)
                labelObjects.append(newPointLabel)
                i += 1
                
                
            }
        }
    }
       
    func clearCache() {
        let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first


        let cachePath = cache!.path
        let filePathName = "\(cachePath)/image"
        do {
            try FileManager.default.removeItem(atPath: filePathName)
        } catch {
            print("no")
            print(error)
        }
           
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in largeImage.subviews {
            view.removeFromSuperview()
        }

        
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
           
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        view.addGestureRecognizer(pinch)
           
        let longgesture = UILongPressGestureRecognizer(target: self, action: #selector(pressHold))
        view.addGestureRecognizer(longgesture)
           
        self.view = view
        
        setupUI()
        setupConstraints()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        ButtonInfo.addTarget(self, action: #selector(DuringButtonPress), for: .touchDown)
        ButtonInfo.addTarget(self, action: #selector(ButtonPress), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Instructions", style: .plain, target: self, action: #selector(InstructionsPress))
        
        BoundingBoxButton.addTarget(self, action: #selector(BoundingBoxButtonPress), for: .touchUpInside)
        PointButton.addTarget(self, action: #selector(PointButtonPress), for: .touchUpInside)
        UnSelectedColorButton.addTarget(self, action: #selector(DESButtonPress), for: .touchUpInside)
        SelectedColorButton.addTarget(self, action: #selector(SELButtonPress), for: .touchUpInside)
        DeleteButton.addTarget(self, action: #selector(DELButtonPress), for: .touchUpInside)
        
        blackButton.addTarget(self, action: #selector(blackButtonPress), for: .touchUpInside)
        redButton.addTarget(self, action: #selector(redButtonPress), for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(greenButtonPress), for: .touchUpInside)
        blueButton.addTarget(self, action: #selector(blueButtonPress), for: .touchUpInside)
        orangeButton.addTarget(self, action: #selector(orangeButtonPress), for: .touchUpInside)
        purpleButton.addTarget(self, action: #selector(purpleButtonPress), for: .touchUpInside)
        yellowButton.addTarget(self, action: #selector(yellowButtonPress), for: .touchUpInside)

        clearCache()
        getImage()
        getCoordinates()
        print(DiskStatus.usedDiskSpace)
        scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLayoutConstraint.deactivate(regularConstraints)
        NSLayoutConstraint.deactivate(compactConstraints)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        super.traitCollectionDidChange(previousTraitCollection)

        layoutTrait(traitCollection: traitCollection)
    }
    
    func setupUI() {
        self.view.addSubview(ButtonInfo)
        view.addSubview(scrollView)
        view.addSubview(ToolBoxStackView)
        view.addSubview(ConnectorView)
        ColorPickerStackView.insertSubview(TotalStackViewBackground, at: 0)
        ColorPickerStackView.addArrangedSubview(blackButton)
        ColorPickerStackView.addArrangedSubview(redButton)
        ColorPickerStackView.addArrangedSubview(greenButton)
        ColorPickerStackView.addArrangedSubview(blueButton)
        ColorPickerStackView.addArrangedSubview(orangeButton)
        ColorPickerStackView.addArrangedSubview(purpleButton)
        ColorPickerStackView.addArrangedSubview(yellowButton)
        view.addSubview(ColorPickerStackView)
        scrollView.addSubview(largeImage)
    }
    
    var compactConstraints: [NSLayoutConstraint] = []
    var regularConstraints: [NSLayoutConstraint] = []

    func setupConstraints() {
        regularConstraints.append(contentsOf: [
            TotalStackViewBackground.topAnchor.constraint(equalTo: ColorPickerStackView.topAnchor, constant: -10),
            TotalStackViewBackground.bottomAnchor.constraint(equalTo: ColorPickerStackView.bottomAnchor, constant: 10),
            TotalStackViewBackground.leadingAnchor.constraint(equalTo: ColorPickerStackView.leadingAnchor, constant: -5),
            TotalStackViewBackground.trailingAnchor.constraint(equalTo: ColorPickerStackView.trailingAnchor, constant: 5),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            largeImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            largeImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            largeImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            largeImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ColorPickerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ColorPickerStackView.bottomAnchor.constraint(equalTo: ToolBoxStackView.topAnchor, constant: -20),
            ToolBoxStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            ToolBoxStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ButtonInfo.topAnchor.constraint(equalTo: ToolBoxStackView.bottomAnchor, constant: 10),
            ButtonInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ButtonInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            ButtonInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            ButtonInfo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            ButtonInfo.heightAnchor.constraint(equalToConstant: 60)
            ])
        compactConstraints.append(contentsOf: [
            TotalStackViewBackground.topAnchor.constraint(equalTo: ColorPickerStackView.topAnchor, constant: -5),
            TotalStackViewBackground.bottomAnchor.constraint(equalTo: ColorPickerStackView.bottomAnchor, constant: 5),
            TotalStackViewBackground.leadingAnchor.constraint(equalTo: ColorPickerStackView.leadingAnchor, constant: -10),
            TotalStackViewBackground.trailingAnchor.constraint(equalTo: ColorPickerStackView.trailingAnchor, constant: 10),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ToolBoxStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ToolBoxStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            ButtonInfo.topAnchor.constraint(equalTo: ToolBoxStackView.bottomAnchor, constant: 10),
            ButtonInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            ButtonInfo.widthAnchor.constraint(equalToConstant: 60),
            ButtonInfo.heightAnchor.constraint(equalToConstant: 60),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leftAnchor.constraint(equalTo: ButtonInfo.rightAnchor, constant: 10),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            largeImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            largeImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            largeImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            largeImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ColorPickerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ColorPickerStackView.leftAnchor.constraint(equalTo: ToolBoxStackView.rightAnchor, constant: 20)
        ])
    }
    
    func layoutTrait(traitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass == .compact {
            ToolBoxStackView.axis = .vertical
            ColorPickerStackView.axis = .vertical
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            ToolBoxStackView.axis = .horizontal
            ColorPickerStackView.axis = .horizontal
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }

    
    func DisplayTextField() {
        self.definesPresentationContext = true
        let vc = TextFieldPopUpViewController()
        //vc.modalPresentationStyle = .overCurrentContext
        //vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        //self.view.addSubview(effectView)
        //self.view.addSubview(effectView)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(vc, animated: false)
        //present(vc, animated: true, completion: nil)
    }

    var RectangleIndexForChangingLabel = 0
    func pass(data:String) {
        print("THE DATA COUNT:")
        print(data.count)
        print(data)
        if data.count > 0 {
            labelObjects[RectangleIndexForChangingLabel].addClassification(" " + data + " ")
        } else {
            labelObjects[RectangleIndexForChangingLabel].addClassification("  +  ")
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func onDataLabelMenuClose(NewLabelType: TypeOfLabel, NewUnSelectedColor: Color, NewSelectedColor: Color) {
        CurrentLabelType = NewLabelType
        UnSelectedColor = NewUnSelectedColor
        SelectedColor = NewSelectedColor
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
       
    func postLabel() {
        var data = ["ImageName": imageData!.name!, "ZipFile": imageData!.ofZipFile!.name!]
        var i = 0
        var j = 0
        for label in labelObjects {
            switch(label) {
                case is BoundingBoxLabel:
                    data["BoundingBox_\(i)_data"] = label.getDataInStringForm()
                    data["BoundingBox_\(i)_color"] = label.getColor()
                    data["BoundingBox_\(i)_classification"] = label.getClassification()
                    i += 1
                default:
                    data["Point_\(j)_data"] = label.getDataInStringForm()
                    data["Point_\(j)_color"] = label.getColor()
                    j += 1
            }
        }
        data["BoundingBox_count"] = String(i)
        data["Point_count"] = String(j)
        CallSendCoordinates(data)
    }

    
    func updateDimension(_ newDimension: Double) {
        dimension = newDimension
        print(dimension)
    }

       
    @objc func InstructionsPress() {
        if largeImage.image != nil {
            self.definesPresentationContext = true
            let vc = PopUpViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    @objc func LabelMenu() {
        /*
        self.definesPresentationContext = true
        let vc = LabelMenuViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.CurrentLabelType = CurrentLabelType
        vc.UnSelectedColor = UnSelectedColor
        vc.SelectedColor = SelectedColor
        //self.view.addSubview(effectView)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        present(vc, animated: true, completion: nil)
        */
    }
    
    @objc func BoundingBoxButtonPress() {
        CurrentLabelType = .boundingBox
        BoundingBoxButton.backgroundColor = .lightGray
        PointButton.backgroundColor = .white
    }
    
    @objc func PointButtonPress() {
        CurrentLabelType = .point
        PointButton.backgroundColor = .lightGray
        BoundingBoxButton.backgroundColor = .white
    }
    
    @objc func DESButtonPress() {
        ColorPickerStackView.isHidden = false
        SelectedOrUnSelectedButton = .UnSelected
        if CurrentColorButtonSelected == nil {
            CurrentColorButtonSelected = blackButton
        } else {
            CurrentColorButtonSelected!.backgroundColor = .white
            switch (UnSelectedColor) {
                case .black:
                    CurrentColorButtonSelected = blackButton
                case .red:
                    CurrentColorButtonSelected = redButton
                case .green:
                    CurrentColorButtonSelected = greenButton
                case .blue:
                    CurrentColorButtonSelected = blueButton
                case .orange:
                    CurrentColorButtonSelected = orangeButton
                case .yellow:
                    CurrentColorButtonSelected = yellowButton
                default: // purple
                    CurrentColorButtonSelected = purpleButton
            }
        }
        CurrentColorButtonSelected!.backgroundColor = .gray
    }
    
    @objc func SELButtonPress() {
        ColorPickerStackView.isHidden = false
        SelectedOrUnSelectedButton = .Selected
        if CurrentColorButtonSelected == nil {
            CurrentColorButtonSelected = redButton
            //CurrentColorButtonSelected!.backgroundColor = .gray
        } else {
            CurrentColorButtonSelected!.backgroundColor = .white
            switch (SelectedColor) {
                case .black:
                    CurrentColorButtonSelected = blackButton
                case .red:
                    CurrentColorButtonSelected = redButton
                case .green:
                    CurrentColorButtonSelected = greenButton
                case .blue:
                    CurrentColorButtonSelected = blueButton
                case .orange:
                    CurrentColorButtonSelected = orangeButton
                case .yellow:
                    CurrentColorButtonSelected = yellowButton
                default: // purple
                    CurrentColorButtonSelected = purpleButton
            }
        }
        CurrentColorButtonSelected!.backgroundColor = .gray
    }
    
    @objc func DELButtonPress() {
        if redItem != nil {
            labelObjects[redItem!].removeShape()
            labelObjects.remove(at: redItem!)
            redItem = nil
        }
    }
    
    @objc func blackButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        blackButton.backgroundColor = .gray
        CurrentColorButtonSelected = blackButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .black
                UnSelectedColorButton.tintColor = .black
            default:
                SelectedColor = .black
                SelectedColorButton.tintColor = .black
        }
    }
    
    @objc func redButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        redButton.backgroundColor = .gray
        CurrentColorButtonSelected = redButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .red
                UnSelectedColorButton.tintColor = .red
            default:
                SelectedColor = .red
                SelectedColorButton.tintColor = .red
        }
        
    }
    
    @objc func greenButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        greenButton.backgroundColor = .gray
        CurrentColorButtonSelected = greenButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .green
                UnSelectedColorButton.tintColor = .green
            default:
                SelectedColor = .green
                SelectedColorButton.tintColor = .green
        }
    }
    
    @objc func blueButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        blueButton.backgroundColor = .gray
        CurrentColorButtonSelected = blueButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .blue
                UnSelectedColorButton.tintColor = .blue
            default:
                SelectedColor = .blue
                SelectedColorButton.tintColor = .blue
        }
    }
    
    @objc func orangeButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        orangeButton.backgroundColor = .gray
        CurrentColorButtonSelected = orangeButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .orange
                UnSelectedColorButton.tintColor = .orange
            default:
                SelectedColor = .orange
                SelectedColorButton.tintColor = .orange
        }
    }
    
    @objc func purpleButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        purpleButton.backgroundColor = .gray
        CurrentColorButtonSelected = purpleButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .purple
                UnSelectedColorButton.tintColor = .purple
            default:
                SelectedColor = .purple
                SelectedColorButton.tintColor = .purple
        }
    }
    
    @objc func yellowButtonPress() {
        CurrentColorButtonSelected!.backgroundColor = .white
        yellowButton.backgroundColor = .gray
        CurrentColorButtonSelected = yellowButton
        switch (SelectedOrUnSelectedButton) {
            case .UnSelected:
                UnSelectedColor = .yellow
                UnSelectedColorButton.tintColor = .yellow
            default:
                SelectedColor = .yellow
                SelectedColorButton.tintColor = .yellow
        }
    }
    
    
       
    @objc func Logout() {
        dismiss(animated: true, completion: nil)
    }
       
    @objc func ButtonPress() {
        if largeImage.image == nil {
            return
        }
        postLabel()
        ButtonInfo.backgroundColor = .systemBlue
        if imageData!.saved == false {
            imageData!.saved = true
            imageData!.ofZipFile!.unsaved_data_count -= 1
            if imageData!.ofZipFile!.unsaved_data_count == 0 {
                imageData!.ofZipFile!.completed = true
            }
            save()
        }
    }
    
    @objc func DuringButtonPress() {
        ButtonInfo.backgroundColor = .gray
    }
    
    
    @objc func pinched(_ sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches < 2 {
            return
        }
        let Ax: Double? = Double(sender.location(ofTouch: 0, in: self.view).x)
        let Ay: Double? = Double(sender.location(ofTouch: 0, in: self.view).y)
        let Bx: Double? = Double(sender.location(ofTouch: 1, in: self.view).x)
        let By: Double? = Double(sender.location(ofTouch: 1, in: self.view).y)
        if redItem != nil {
            switch (labelObjects[redItem!]) {
                case is BoundingBoxLabel:
                    let redLabelObject = labelObjects[redItem!]
                    redLabelObject.changeShapeSize(Ax!, Ay!, Bx!, By!)
                default:
                    print("start")
                    for items in labelObjects {
                        if items is PointLabel {
                            items.changeShapeSize(Ax!, Ay!, Bx!, By!)
                        }
                            
                    }
                
            }
        }
           
    }
    
    @objc func Tapped(sender:UITapGestureRecognizer) {
        print("REACHED")
        if sender.state == .ended {
            let touchLocation: CGPoint = sender.location(in: sender.view)
            let offsetX = Double(scrollView.contentOffset.x)
            let offsetY = Double(scrollView.contentOffset.y)
            let x = Double(touchLocation.x) + offsetX - Double(scrollView.frame.origin.x)
            let y = Double(touchLocation.y) + offsetY - Double(scrollView.frame.origin.y)
            if ColorPickerStackView.isHidden == false {
                print(TotalStackViewBackground.frame.origin.y)
                let minX = ColorPickerStackView.frame.origin.x + TotalStackViewBackground.frame.origin.x
                let maxX = minX + ColorPickerStackView.frame.size.width - TotalStackViewBackground.frame.origin.x
                let minY = ColorPickerStackView.frame.origin.y + TotalStackViewBackground.frame.origin.y
                let maxY = minY + ColorPickerStackView.frame.size.height - TotalStackViewBackground.frame.origin.y
                print(maxY)
                print(touchLocation.y)
                if Double(touchLocation.x) < Double(minX) || Double(touchLocation.x) > Double(maxX) || Double(touchLocation.y) < Double(minY) || Double(touchLocation.y) > Double(maxY) {
                    ColorPickerStackView.isHidden = true
                }
                return
            }
            if touchLocation.x < scrollView.frame.origin.x {
                return
            }
            if touchLocation.x > scrollView.frame.origin.x + scrollView.frame.size.width {
                return
            }
            if touchLocation.y < scrollView.frame.origin.y {
                return
            }
            if touchLocation.y > scrollView.frame.origin.y + scrollView.frame.size.height {
                return
            }
            if redItem != nil {
                let intersectionResult = labelObjects[redItem!].intersection(x, y)
                if intersectionResult == .shape {
                    labelObjects[redItem!].removeShape()
                    labelObjects.remove(at: redItem!)
                    redItem = nil
                    return
                } else if intersectionResult == .none {
                    print("YESYESYESYES")
                    labelObjects[redItem!].makeUnSelectedColor()
                    redItem = nil
                    return
                }
            }
            for (i, labelObject) in labelObjects.enumerated() {
                let intersectionResult = labelObjects[i].intersection(x, y)
                if intersectionResult == .shape {
                    redItem = i
                    labelObject.makeSelectedColor()
                    return
                } else if intersectionResult == .label {
                    RectangleIndexForChangingLabel = i
                    DisplayTextField()
                    print("FINISHED")
                    return
                }
            }
            if touchLocation.x < scrollView.frame.origin.x {
                return
            }
            if touchLocation.x > scrollView.frame.origin.x + scrollView.frame.size.width {
                return
            }
            if touchLocation.y < scrollView.frame.origin.y {
                return
            }
            if touchLocation.y > scrollView.frame.origin.y + scrollView.frame.size.height {
                return
            }
            switch (CurrentLabelType) {
                case .boundingBox:
                    labelObjects.append(BoundingBoxLabel(x: x, y: y, delegate: self))
                default:
                    labelObjects.append(PointLabel(x: x, y: y, dimension: dimension, delegate: self))
            }
            labelObjects.last!.createShape()
        }
    }
    
    
    var Selector = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
    var StartX: CGFloat = 0
    var StartY: CGFloat = 0
    var HighlightedSelected = -1
    @objc func pressHold(_ sender: UILongPressGestureRecognizer) {
        ButtonInfo.backgroundColor = .systemBlue
        let offsetX = Double(scrollView.contentOffset.x)
        let offsetY = Double(scrollView.contentOffset.y)
        let x = Double(sender.location(ofTouch: 0, in: self.view).x) + offsetX - Double(scrollView.frame.origin.x)
        let y = Double(sender.location(ofTouch: 0, in: self.view).y) + offsetY - Double(scrollView.frame.origin.y)
        if sender.state == .began {
            print("It has begun")
            largeImage.addSubview(Selector)
            Selector.frame.origin.x = CGFloat(x)
            Selector.frame.origin.y = CGFloat(y)
            StartX = CGFloat(x)
            StartY = CGFloat(y)
            switch (UnSelectedColor) {
                case .black:
                    Selector.layer.borderColor = UIColor.black.cgColor
                case .red:
                    Selector.layer.borderColor = UIColor.red.cgColor
                case .green:
                    Selector.layer.borderColor = UIColor.green.cgColor
                case .blue:
                    Selector.layer.borderColor = UIColor.blue.cgColor
                case .orange:
                    Selector.layer.borderColor = UIColor.orange.cgColor
                case .purple:
                    Selector.layer.borderColor = UIColor.purple.cgColor
                default:
                    Selector.layer.borderColor = UIColor.yellow.cgColor
            }
            Selector.layer.borderWidth = 4
        }
        if sender.state == .ended {
            Selector.removeFromSuperview()
            Selector.frame.size.width = 0
            Selector.frame.size.height = 0
            print(HighlightedSelected)
            if HighlightedSelected != -1 {
                redItem = HighlightedSelected
            }
            HighlightedSelected = -1
            return
        }
        if redItem != nil {
            labelObjects[redItem!].moveShape(x, y)
        } else {
            //largeImage.addSubview(Selector)
            UIView.animate(withDuration: 0.1) {
                if CGFloat(x) < self.StartX && CGFloat(y) < self.StartY {
                    self.Selector.frame.origin.x = CGFloat(x)
                    self.Selector.frame.origin.y = CGFloat(y)
                    self.Selector.frame.size.width = self.StartX - CGFloat(x)
                    self.Selector.frame.size.height = self.StartY - CGFloat(y)
                }
                if CGFloat(x) >= self.StartX && CGFloat(y) < self.StartY {
                    print("We are in Correct")
                    self.Selector.frame.origin.x = self.StartX
                    self.Selector.frame.origin.y = CGFloat(y)
                    self.Selector.frame.size.width = CGFloat(x) - self.StartX
                    self.Selector.frame.size.height = self.StartY - CGFloat(y)
                }
                if CGFloat(x) >= self.StartX && CGFloat(y) >= self.StartY {
                    self.Selector.frame.origin.x = self.StartX
                    self.Selector.frame.origin.y = self.StartY
                    self.Selector.frame.size.width = CGFloat(x) - self.StartX
                    self.Selector.frame.size.height = CGFloat(y) - self.StartY
                }
                if CGFloat(x) < self.StartX && CGFloat(y) >= self.StartY {
                    self.Selector.frame.origin.x = CGFloat(x)
                    self.Selector.frame.origin.y = self.StartY
                    self.Selector.frame.size.width = self.StartX - CGFloat(x)
                    self.Selector.frame.size.height = CGFloat(y) - self.StartY
                }
            }
            if HighlightedSelected > -1 {
                labelObjects[HighlightedSelected].makeUnSelectedColor()
            }
            let minX = Double(Selector.frame.origin.x)
            let maxX = Double(Selector.frame.origin.x + Selector.frame.size.width)
            let minY = Double(Selector.frame.origin.y)
            let maxY = Double(Selector.frame.origin.y + Selector.frame.size.height)
            var minDistance: Double = 10000
            var minDistanceIndex: Int = -1
            for (i, labelObject) in labelObjects.enumerated() {
                if labelObject.x >= minX && labelObject.x <= maxX && labelObject.y >= minY && labelObject.y <= maxY {
                    let distance = pow(pow(labelObject.x - x, 2) + pow(labelObject.y - y, 2), 0.5)
                    if distance < minDistance {
                        minDistance = distance
                        minDistanceIndex = i
                    }
                }
            }
            if minDistanceIndex > -1 {
                labelObjects[minDistanceIndex].makeSelectedColor()
            }
            HighlightedSelected = minDistanceIndex
            
        }
        print(Selector.frame.size.width)
           
    }
}


