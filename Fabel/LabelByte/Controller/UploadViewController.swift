//
//  UploadViewController.swift
//  LabelByte
//
//  Created by Sachin Guliani on 1/6/21.
//

import UIKit

class UploadViewController: UIViewController, DocumentDelegate {
    
    unowned var delegate: FileTableViewController?

    var currentUploadView = UploadView()
    var Background: UIView { return currentUploadView.Background }
    var Label: UILabel { return currentUploadView.Label }
    var Select: UIButton { return currentUploadView.Select }
    var FileName: UILabel { return currentUploadView.FileName }
    var Upload: UIButton { return currentUploadView.Upload }
    var HorizontalStackView: UIStackView { return currentUploadView.HorizontalStackView }
    var Status: UILabel { return currentUploadView.Status }
    var Note: UILabel { return currentUploadView.Note }
    
    func didPickDocuments(documents: [Document]?) {
        /*
        for items in documents! {
            let fileURL = items.fileURL
            print(fileURL)
        }
        */
        let fileURL = documents?[0].fileURL
        //delegate!.fileURL = fileURL!
        //delegate!.doStuff(fileURL!)
        if let openedfileURL = fileURL {
            let fileURLName = openedfileURL.lastPathComponent
            FileName.text = fileURLName
            uploadFileURL = fileURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.Select.addTarget(self, action: #selector(SelectButtonPress), for: .touchUpInside)
        self.Select.addTarget(self, action: #selector(DuringSelectButtonPress), for: .touchDown)
        self.Upload.addTarget(self, action: #selector(UploadButtonPress), for: .touchUpInside)
        self.Upload.addTarget(self, action: #selector(DuringUploadButtonPress), for: .touchDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        delegate!.navigationController?.setNavigationBarHidden(true, animated: false)
        
        documentPicker = DocumentPicker(presentationController: self, delegate: self)
        
        setupUI()
        setupConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        super.traitCollectionDidChange(previousTraitCollection)

        layoutTrait(traitCollection: traitCollection)
    }
    
    func setupUI() {
        //HorizontalStackView.addArrangedSubview(Select)
        //HorizontalStackView.addArrangedSubview(FileName)
        //HorizontalStackView.addArrangedSubview(Upload)
        Background.addSubview(Label)
        Background.addSubview(Select)
        Background.addSubview(FileName)
        Background.addSubview(Upload)
        //Background.addSubview(HorizontalStackView)
        view.addSubview(Background)
        view.addSubview(Status)
        view.addSubview(Note)
    }
    
    var compactConstraints: [NSLayoutConstraint] = []
    var regularConstraints: [NSLayoutConstraint] = []
    
    func setupConstraints() {
        regularConstraints.append(contentsOf: [
            //Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Label.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Label.topAnchor.constraint(equalTo: Background.topAnchor, constant: 10),
            //HorizontalStackView.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            //HorizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Select.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            Select.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Select.widthAnchor.constraint(equalToConstant: 80),
            Select.heightAnchor.constraint(equalToConstant: 40),
            FileName.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 20),
            FileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Upload.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            Upload.rightAnchor.constraint(equalTo: Background.rightAnchor, constant: -10),
            Upload.widthAnchor.constraint(equalToConstant: 80),
            Upload.heightAnchor.constraint(equalToConstant: 40),
            //Status.topAnchor.constraint(equalTo: HorizontalStackView.bottomAnchor, constant: 10),
            //Status.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Status.topAnchor.constraint(equalTo: FileName.bottomAnchor, constant: 10),
            //Status.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Status.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Note.topAnchor.constraint(equalTo: Status.bottomAnchor, constant: 10),
            //Note.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Note.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Background.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Background.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            Background.heightAnchor.constraint(equalToConstant: 310),
            Background.widthAnchor.constraint(equalToConstant: 300)
        ])
        compactConstraints.append(contentsOf: [
            //Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Label.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Label.topAnchor.constraint(equalTo: Background.topAnchor, constant: 10),
            //HorizontalStackView.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            //HorizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Select.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            Select.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Select.widthAnchor.constraint(equalToConstant: 80),
            Select.heightAnchor.constraint(equalToConstant: 40),
            FileName.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 20),
            FileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Upload.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 10),
            Upload.rightAnchor.constraint(equalTo: Background.rightAnchor, constant: -10),
            Upload.widthAnchor.constraint(equalToConstant: 80),
            Upload.heightAnchor.constraint(equalToConstant: 40),
            //Status.topAnchor.constraint(equalTo: HorizontalStackView.bottomAnchor, constant: 10),
            //Status.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Status.topAnchor.constraint(equalTo: Select.bottomAnchor, constant: 10),
            //Status.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Status.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Note.topAnchor.constraint(equalTo: Status.bottomAnchor, constant: 10),
            //Note.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Note.leftAnchor.constraint(equalTo: Background.leftAnchor, constant: 10),
            Background.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Background.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            Background.heightAnchor.constraint(equalToConstant: 310),
            Background.widthAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    func layoutTrait(traitCollection: UITraitCollection) {
        // Sets up Instructions differently horizontally for iphones
        // so it fits on screen
        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    /*
    override func loadView() {
        let view = UploadView()

        self.view = view
        
    }
    */
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    */
    
    var documentPicker: DocumentPicker!
    var uploadFileURL: URL? = nil
    
    //unowned var MainView: UploadView { return self.view as! UploadView }
    //unowned var SelectButton: UIButton { return MainView.Select }
    //unowned var FileNameLabel: UILabel { return MainView.FileName }
    
    func doStuff(_ fileURL: URL) {
        let fileName = fileURL.lastPathComponent
        print(fileName)
    }
    
    func runUploadZipFile(_ file: URL) -> String {
        var error = ""
        let semaphore = DispatchSemaphore(value: 0)
        UploadZipFile(file) { output in
            error = output
            semaphore.signal()
        }
        semaphore.wait()
        return error
    }
    
    func updateStatus() -> String {
        if let file = uploadFileURL {
            let error = runUploadZipFile(file)
            if error == "Error" {
                return "Status: Error"
            }
            let jsonData = error.data(using: .utf8)!
            let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
            // Use parsed data to create labels and display them
            if let Data = dictionary as? [String: String] {
                let result = Data["result"]!
                let result_spaces = result.components(separatedBy: " ")
                if result == "" {
                    return "Status: File Uploaded"
                } else {
                    if result_spaces.count > 3 {
                        let first_part = result_spaces[0...3]
                        let second_part = result_spaces[4..<result_spaces.count]
                        return "Status: " + first_part.joined(separator: " ") + "\n" + second_part.joined(separator: " ")
                    } else {
                        return "Status: " + result
                    }
                }
            }
        }
        return ""
    }
    
    @objc func DuringSelectButtonPress() {
        Select.backgroundColor = .gray
    }
    
    @objc func DuringUploadButtonPress() {
        Upload.backgroundColor = .gray
    }

    @objc func SelectButtonPress() {
        print("Reached")
        //let VC = DocumentPickerViewController()
        //VC.delegate = self
        //present(VC, animated: true)
        /*
        let documentPicker = DocumentPicker(presentationController: self, delegate: self)
        documentPicker.present(from: view)
        */
        documentPicker.present(from: view)
        Select.backgroundColor = .systemBlue
    }
    
    @objc func UploadButtonPress() {
        if uploadFileURL == nil {
            Upload.backgroundColor = .systemBlue
            return
        }
        Status.text = "Status: Uploading"
        DispatchQueue.global(qos: .background).async {
            let val = self.updateStatus()
            DispatchQueue.main.async {
                self.Status.text = val
            }
        }
        /*
        if let file = uploadFileURL {
            let error = runUploadZipFile(file)
            let jsonData = error.data(using: .utf8)!
            let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
            // Use parsed data to create labels and display them
            if let Data = dictionary as? [String: String] {
                let result = Data["result"]!
                let result_spaces = result.components(separatedBy: " ")
                if result == "" {
                    Status.text = "Status: File Uploaded"
                } else {
                    if result_spaces.count > 3 {
                        let first_part = result_spaces[0...3]
                        let second_part = result_spaces[4..<result_spaces.count]
                        Status.text = "Status: " + first_part.joined(separator: " ") + "\n" + second_part.joined(separator: " ")
                        print(Status.text)
                    } else {
                        Status.text = "Status: " + result
                    }
                }
            }
        }
        */
        Upload.backgroundColor = .systemBlue
    }
    
    @objc func Tapped(sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            /*
            let touchLocation: CGPoint = sender.location(in: sender.view)
            let x = touchLocation.x
            let y = touchLocation.y
            let minX = Background.frame.minX
            let minY = Background.frame.minY
            let maxX = Background.frame.maxX
            let maxY = Background.frame.maxY
            if x < minX || x > maxX || y < minY || y > maxY {
                dismiss(animated: false, completion: nil)
            }
            */
            delegate!.Refresh(true)
            delegate!.navigationController?.setNavigationBarHidden(false, animated: false)
            dismiss(animated: false, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
