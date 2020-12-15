//
//  ImageViewController.swift
//  LabelByte
//
//  Created by Sachin Guliani on 8/12/20.
//

import UIKit
import CoreData

class ImageViewController: UIViewController, UIScrollViewDelegate, isAbleToReceiveData {
    
    var labelObjects = [LabelOperations]()
    
    var imageData: Data?
       
    var selectedItem: Int? = nil

    var dimension = Double(15)
    
    var SaveOperation = LimitedOperation(limit: 10)
    
    func getImage() {
        // Gets Image from server
        var image: UIImage? = UIImage()
        // Uses semaphore to wait for network call till data recieved
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
    
    func displaySuccess(_ message: String) {
        self.definesPresentationContext = true
        let success_vc = SuccessViewController()
        success_vc.modalPresentationStyle = .overCurrentContext
        success_vc.modalTransitionStyle = .crossDissolve
        success_vc.message = message
        present(success_vc, animated: true, completion: nil)
    }
    
    
    func CallSendCoordinates(_ data: [String: String]) -> String {
        // Sends Label Data to server
        var result = ""
        // Uses semaphore to wait for network call till data recieved
        let semaphore = DispatchSemaphore(value: 0)
        SendCoordinates(data) { output in
            result = output
            semaphore.signal()
        }
        semaphore.wait()
        // Make Saved message
        return result
    }
       
    func getCoordinates() {
        // Get Label Data from server
        var DictString = ""
        let semaphore = DispatchSemaphore(value: 0)
        // Uses semaphore to wait for network call till data recieved
        GETCoordinates(imageData!.ofZipFile!.name!, imageData!.name!) { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        // Parse DictString to usable format
        let jsonData = DictString.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        // Use parsed data to create labels and display them
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
       

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
           
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        view.addGestureRecognizer(pinch)
           
        let longgesture = UILongPressGestureRecognizer(target: self, action: #selector(pressHold))
        view.addGestureRecognizer(longgesture)

           
        self.view = view
        
        ToolBoxStackView = createToolBox()
        //ToolBoxVerticalStackView = createVerticalToolBox()
        
        setupUI()
        setupConstraints()
        
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Label Image"
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

        getImage()
        getCoordinates()
        
        scrollView.delegate = self
    }

    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Deactivates previous constraints before setting new constrains
        NSLayoutConstraint.deactivate(regularConstraints)
        NSLayoutConstraint.deactivate(compactConstraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        super.traitCollectionDidChange(previousTraitCollection)

        layoutTrait(traitCollection: traitCollection)
    }
    
    
    func createToolBox() -> UIStackView {
        ToolStackView.addArrangedSubview(BoundingBoxButton)
        ToolStackView.addArrangedSubview(PointButton)
        ToolStackView.addArrangedSubview(UnSelectedColorButton)
        ToolStackView.addArrangedSubview(SelectedColorButton)
        ToolStackView.addArrangedSubview(DeleteButton)
        return ToolStackView
    }
    
    var ToolBoxStackView: UIStackView?

    var ImageViewVar = ImageViewVariables()
    var ToolBoxView = ToolBoxFunction()

    var BoundingBoxButton: UIButton { return ToolBoxView.BoundingBoxButton }
    var PointButton: UIButton { return ToolBoxView.PointButton }
    var UnSelectedColorButton: UIButton { return ToolBoxView.UnSelectedColorButton }
    var SelectedColorButton: UIButton { return ToolBoxView.SelectedColorButton }
    var DeleteButton: UIButton { return ToolBoxView.DeleteButton }
    var ToolStackView: UIStackView { return ToolBoxView.ToolStackView }

    var scrollView: UIScrollView { return ImageViewVar.scrollView }
    var ButtonInfo: UIButton { return ImageViewVar.ButtonInfo }
    var TotalStackViewBackground: UIView { return ImageViewVar.TotalStackViewBackground }
    var ConnectorView: UIView { return ImageViewVar.ConnectorView }
    var ColorPickerStackView: UIStackView { return ImageViewVar.ColorPickerStackView }
    var blackButton: UIButton { return ImageViewVar.blackButton }
    var redButton: UIButton { return ImageViewVar.redButton }
    var greenButton: UIButton { return ImageViewVar.greenButton }
    var blueButton: UIButton { return ImageViewVar.blueButton }
    var orangeButton: UIButton { return ImageViewVar.orangeButton }
    var purpleButton: UIButton { return ImageViewVar.purpleButton }
    var yellowButton: UIButton { return ImageViewVar.yellowButton }
    var largeImage: UIImageView { return ImageViewVar.largeImage }

    func setupUI() {
        ToolBoxStackView = createToolBox()
        //ToolBoxVerticalStackView = createVerticalToolBox()
        self.view.addSubview(ButtonInfo)
        view.addSubview(scrollView)
        view.addSubview(ToolBoxStackView!)
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
        switch (CurrentLabelType) {
        case .boundingBox:
            BoundingBoxButtonPress()
        default:
            PointButtonPress()
        }
        switch (UnSelectedColor) {
        case .black:
            UnSelectedColorButton.tintColor = .black
        case .red:
            UnSelectedColorButton.tintColor = .red
        case .green:
            UnSelectedColorButton.tintColor = .green
        case .blue:
            UnSelectedColorButton.tintColor = .blue
        case .orange:
            UnSelectedColorButton.tintColor = .orange
        case .purple:
            UnSelectedColorButton.tintColor = .purple
        default:
            UnSelectedColorButton.tintColor = .yellow
        }
        switch (SelectedColor) {
        case .black:
            SelectedColorButton.tintColor = .black
        case .red:
            SelectedColorButton.tintColor = .red
        case .green:
            SelectedColorButton.tintColor = .green
        case .blue:
            SelectedColorButton.tintColor = .blue
        case .orange:
            SelectedColorButton.tintColor = .orange
        case .purple:
            SelectedColorButton.tintColor = .purple
        default:
            SelectedColorButton.tintColor = .yellow
        }
    }
    
    var compactConstraints: [NSLayoutConstraint] = []
    var regularConstraints: [NSLayoutConstraint] = []

    func setupConstraints() {
        //let first = (self.view.frame.width < self.view.frame.height) && (self.view.frame.height < 600)
        //let second = (self.view.frame.width >= self.view.frame.height) && (self.view.frame.height < 330)
        let largest = max(self.view.frame.width, self.view.frame.height)
        if largest < 600 {
            BoundingBoxButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            BoundingBoxButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            PointButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            PointButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            UnSelectedColorButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            UnSelectedColorButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            SelectedColorButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            SelectedColorButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            DeleteButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            DeleteButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            blackButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            blackButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            redButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            redButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            greenButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            greenButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            blueButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            blueButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            orangeButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            orangeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            purpleButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            purpleButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            yellowButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            yellowButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            
        }
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
            ColorPickerStackView.bottomAnchor.constraint(equalTo: ToolBoxStackView!.topAnchor, constant: -20),
            ToolBoxStackView!.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            ToolBoxStackView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ButtonInfo.topAnchor.constraint(equalTo: ToolBoxStackView!.bottomAnchor, constant: 10),
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
            ToolBoxStackView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ToolBoxStackView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            ButtonInfo.topAnchor.constraint(equalTo: ToolBoxStackView!.bottomAnchor, constant: 10),
            ButtonInfo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
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
            ColorPickerStackView.leftAnchor.constraint(equalTo: ToolBoxStackView!.rightAnchor, constant: 20)
        ])
    }
    
    func layoutTrait(traitCollection: UITraitCollection) {
        // Set up view differently for horizontal and vertical for iphones
        if traitCollection.verticalSizeClass == .compact {
            ToolBoxStackView?.axis = .vertical
            ColorPickerStackView.axis = .vertical
            //BoundingBoxButton.frame.size.width = 20.0
            //BoundingBoxButton.frame.size.height = 20.0
            //PointButton.frame.size.width = 20.0
            //PointButton.frame.size.height = 20.0
            //UnSelectedColorButton.frame.size.width = 20.0
            //UnSelectedColorButton.frame.size.height = 20.0
            //SelectedColorButton.frame.size.width = 20.0
            //SelectedColorButton.frame.size.height = 20.0
            //DeleteButton.frame.size.width = 20.0
            //DeleteButton.frame.size.height = 20.0
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            ToolBoxStackView?.axis = .horizontal
            ColorPickerStackView.axis = .horizontal
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }

    func DisplayTextField(_ currentText: String) {
        // Sets up textfield for classification
        self.definesPresentationContext = true
        let vc = TextFieldPopUpViewController()
        vc.currentText = currentText
        vc.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    var RectangleIndexForChangingLabel = 0
    func pass(data:String) {
        // Takes text label data and attaches classification to label
        labelObjects[RectangleIndexForChangingLabel].addClassification(data)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

       
    func postLabel() -> String {
        // Packages Label Data and sends it to server
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
        //print("HERE IS DATA SENT TO SERVER:")
        //print(data)
        return CallSendCoordinates(data)
    }


    func updateDimension(_ newDimension: Double) {
        // Updates Point label dimension so all future point labels can be same size
        // of currently display point labels
        dimension = newDimension
    }

    
       
    @objc func InstructionsPress() {
        // Displays Instructions
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if largeImage.image != nil {
            self.definesPresentationContext = true
            let popup_vc = PopUpViewController()
            popup_vc.delegate = self
            popup_vc.modalPresentationStyle = .overCurrentContext
            popup_vc.modalTransitionStyle = .crossDissolve
            present(popup_vc, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    @objc func BoundingBoxButtonPress() {
        // Sets Label type to Bounding Box
        CurrentLabelType = .boundingBox
        BoundingBoxButton.backgroundColor = .lightGray
        PointButton.backgroundColor = .white
    }
    
    @objc func PointButtonPress() {
        // Sets Label type to Point
        CurrentLabelType = .point
        PointButton.backgroundColor = .lightGray
        BoundingBoxButton.backgroundColor = .white
    }
    
    @objc func DESButtonPress() {
        // DeSelected or UnSelected
        // Allows you to choose UnSelected Color type
        // from color chooser
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
        // Allows you to choose Selected Color type
        // from color chooser
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
        // Deletes Selected Object when pressed
        if selectedItem != nil {
            labelObjects[selectedItem!].removeShape()
            labelObjects.remove(at: selectedItem!)
            selectedItem = nil
        }
    }
    
    @objc func blackButtonPress() {
        // Makes UnSelected or Selected Black
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
        // Makes UnSelected or Selected Red
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
        // Makes UnSelected or Selected green
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
        // Makes UnSelected or Selected Blue
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
        // Makes UnSelected or Selected Orange
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
        // Makes UnSelected or Selected Purple
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
        // Makes UnSelected or Selected Yellow
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
    
    @objc func ButtonPress() {
        // Calls postLabel() when saved button pressed
        if largeImage.image == nil {
            return
        }
        // Make a selected object unselected
        if selectedItem != nil {
            labelObjects[selectedItem!].makeUnSelectedColor()
            selectedItem = nil
        }
        ButtonInfo.backgroundColor = .systemBlue
        // Blocks excessive saves
        var message = "Blocked 300 Seconds"
        if SaveOperation.incrementToLimit() == true {
            message = postLabel()
            // Once Saved sets Image as complete in DataTableVC
            if imageData!.saved == false {
                imageData!.saved = true
                imageData!.ofZipFile!.unsaved_data_count -= 1
                if imageData!.ofZipFile!.unsaved_data_count == 0 {
                    imageData!.ofZipFile!.completed = true
                }
                save()
            }
            displaySuccess(message)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func DuringButtonPress() {
        ButtonInfo.backgroundColor = .gray
    }
    
    
    @objc func pinched(_ sender: UIPinchGestureRecognizer) {
        // Expands or shrinks label based on pinch
        if sender.numberOfTouches < 2 {
            // If one finger removed from singer during pinch gesture return
            return
        }
        let Ax: Double? = Double(sender.location(ofTouch: 0, in: self.view).x)
        let Ay: Double? = Double(sender.location(ofTouch: 0, in: self.view).y)
        let Bx: Double? = Double(sender.location(ofTouch: 1, in: self.view).x)
        let By: Double? = Double(sender.location(ofTouch: 1, in: self.view).y)
        if selectedItem != nil {
            switch (labelObjects[selectedItem!]) {
                case is BoundingBoxLabel:
                    let redLabelObject = labelObjects[selectedItem!]
                    redLabelObject.changeShapeSize(Ax!, Ay!, Bx!, By!)
                default:
                    for items in labelObjects {
                        if items is PointLabel {
                            items.changeShapeSize(Ax!, Ay!, Bx!, By!)
                        }
                            
                    }
                
            }
        }
           
    }
    
    @objc func Tapped(sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            let touchLocation: CGPoint = sender.location(in: sender.view)
            let offsetX = Double((scrollView.contentOffset.x))
            let offsetY = Double((scrollView.contentOffset.y))
            let x = Double(touchLocation.x) + offsetX - Double(scrollView.frame.origin.x)
            let y = Double(touchLocation.y) + offsetY - Double(scrollView.frame.origin.y)
            // Check if Color Chooser button selected
            if ColorPickerStackView.isHidden == false {
                let minX = (ColorPickerStackView.frame.origin.x) + (TotalStackViewBackground.frame.origin.x)
                let maxX = minX + ColorPickerStackView.frame.size.width - TotalStackViewBackground.frame.origin.x
                let minY = (ColorPickerStackView.frame.origin.y) + (TotalStackViewBackground.frame.origin.y)
                let maxY = minY + ColorPickerStackView.frame.size.height - TotalStackViewBackground.frame.origin.y
                // Exits out of Color Chooser if touching outside Color Chooser
                if Double(touchLocation.x) < Double(minX) || Double(touchLocation.x) > Double(maxX) || Double(touchLocation.y) < Double(minY) || Double(touchLocation.y) > Double(maxY) {
                    ColorPickerStackView.isHidden = true
                }
                return
            }
            // Dont do anything when outside scroll view or not touching buttons
            if touchLocation.x < (scrollView.frame.origin.x) {
                return
            }
            if touchLocation.x > (scrollView.frame.origin.x) + (scrollView.frame.size.width) {
                return
            }
            if touchLocation.y < (scrollView.frame.origin.y) {
                return
            }
            if touchLocation.y > (scrollView.frame.origin.y) + (scrollView.frame.size.height) {
                return
            }
            // When there is a selected label
            // if touched inside delete
            // if touched outside make in unselected
            if selectedItem != nil {
                let intersectionResult = labelObjects[selectedItem!].intersection(x, y)
                if intersectionResult == .shape {
                    labelObjects[selectedItem!].removeShape()
                    labelObjects.remove(at: selectedItem!)
                    selectedItem = nil
                    return
                } else if intersectionResult == .none {
                    labelObjects[selectedItem!].makeUnSelectedColor()
                    selectedItem = nil
                    return
                }
            }
            // Check if label was selected - if so make it selected
            // Check if Bounding Box + for adding classification is selected
            for (i, labelObject) in labelObjects.enumerated() {
                let intersectionResult = labelObjects[i].intersection(x, y)
                if intersectionResult == .shape {
                    selectedItem = i
                    labelObject.makeSelectedColor()
                    return
                } else if intersectionResult == .label {
                    RectangleIndexForChangingLabel = i
                    DisplayTextField(labelObject.getClassification())
                    return
                }
            }
            // Add Label Type depending on whether BoundingBox of Point is selected
            if labelObjects.count < labelsPerImage {
                switch (CurrentLabelType) {
                    case .boundingBox:
                        labelObjects.append(BoundingBoxLabel(x: x, y: y, delegate: self))
                    default:
                        labelObjects.append(PointLabel(x: x, y: y, dimension: dimension, delegate: self))
                }
                labelObjects.last!.createShape()
            }
        }
    }
    
    
    var Selector = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
    var StartX: CGFloat = 0
    var StartY: CGFloat = 0
    var HighlightedSelected = -1
    @objc func pressHold(_ sender: UILongPressGestureRecognizer) {
        ButtonInfo.backgroundColor = .systemBlue
        let offsetX = Double((scrollView.contentOffset.x))
        let offsetY = Double((scrollView.contentOffset.y))
        let x = Double(sender.location(ofTouch: 0, in: self.view).x) + offsetX - Double(scrollView.frame.origin.x)
        let y = Double(sender.location(ofTouch: 0, in: self.view).y) + offsetY - Double(scrollView.frame.origin.y)
        // Set up Selector
        if sender.state == .began {
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
        // Remove Selector
        if sender.state == .ended {
            Selector.removeFromSuperview()
            Selector.frame.size.width = 0
            Selector.frame.size.height = 0
            if HighlightedSelected != -1 {
                selectedItem = HighlightedSelected
            }
            HighlightedSelected = -1
            return
        }
        // If there is a Selected Item move it
        // Otherwise Enlarge Selector
        if selectedItem != nil {
            labelObjects[selectedItem!].moveShape(x, y)
        } else {
            // Dealing with different case depending on quadrant finger is in
            // with reference to starting point of selector
            UIView.animate(withDuration: 0.1) {
                if CGFloat(x) < self.StartX && CGFloat(y) < self.StartY {
                    self.Selector.frame.origin.x = CGFloat(x)
                    self.Selector.frame.origin.y = CGFloat(y)
                    self.Selector.frame.size.width = self.StartX - CGFloat(x)
                    self.Selector.frame.size.height = self.StartY - CGFloat(y)
                }
                if CGFloat(x) >= self.StartX && CGFloat(y) < self.StartY {
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
            // Make a selected object unselected
            if HighlightedSelected > -1 {
                labelObjects[HighlightedSelected].makeUnSelectedColor()
            }
            let minX = Double(Selector.frame.origin.x)
            let maxX = Double(Selector.frame.origin.x + Selector.frame.size.width)
            let minY = Double(Selector.frame.origin.y)
            let maxY = Double(Selector.frame.origin.y + Selector.frame.size.height)
            var minDistance: Double = 10000
            var minDistanceIndex: Int = -1
            // Check if Selector surrounds label
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
           
    }
}

