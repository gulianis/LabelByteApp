//
//  DocumentPickerViewController.swift
//  LabelByte
//
//  Created by Sandeep Guliani on 1/11/21.
//

import UIKit

class DocumentPickerViewController: UIViewController, DocumentDelegate {

    func didPickDocuments(documents: [Document]?) {
        let fileURL = documents?[0].fileURL
        delegate!.doStuff(fileURL!)
        dismiss(animated: true)
    }
    
    var documentPicker: DocumentPicker!
    unowned var delegate: UploadViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        documentPicker = DocumentPicker(presentationController: self, delegate: self)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //presentPicker()
        documentPicker.present(from: view)

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
