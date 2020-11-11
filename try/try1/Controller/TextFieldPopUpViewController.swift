//
//  TextFieldPopUpViewController.swift
//  try1
//
//  Created by Sandeep Guliani on 10/28/20.
//

import UIKit

class TextFieldPopUpViewController: UIViewController {

    var delegate: isAbleToReceiveData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
            let view = TextFieldPopUpView()
            //let view = TextFieldPopUpView()
            view.backgroundColor = .darkGray    
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
            tap.numberOfTapsRequired = 1
            view.addGestureRecognizer(tap)

            self.view = view
            
    }
        
    @objc func Tapped(sender:UITapGestureRecognizer) {
        delegate!.pass(data: TextField.text!)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height) / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    unowned var MainView: TextFieldPopUpView { return self.view as! TextFieldPopUpView }
    unowned var TextField: UITextField { return MainView.TextField }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
