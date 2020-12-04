//
//  TextFieldPopUpViewController.swift
//  try1
//
//  Created by Sachin Guliani on 10/28/20.
//

import UIKit

class TextFieldPopUpViewController: UIViewController, UITextFieldDelegate {

    var delegate: isAbleToReceiveData?
    var currentText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextField.delegate = self
        
        TextField.text = currentText
        
        // Detect Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
            let view = TextFieldPopUpView()

            view.backgroundColor = .darkGray    
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)

            self.view = view
            
    }
    
    unowned var MainView: TextFieldPopUpView { return self.view as! TextFieldPopUpView }
    unowned var TextField: UITextField { return MainView.TextField }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Limits amount of text than can be written in text field
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 15
    }
        
    @objc func Tapped(sender:UITapGestureRecognizer) {
        // Pass Data back and return to screen when tapped outside of textfield
        delegate!.pass(data: TextField.text!)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Push up textbox when keyboard shows up
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height) / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Put textbox in original position when keyboard gone
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
