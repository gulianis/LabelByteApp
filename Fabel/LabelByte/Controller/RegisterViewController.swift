//
//  RegisterViewController.swift
//  LabelByte
//
//  Created by Sachin Guliani on 1/24/21.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.RegisterButton.addTarget(self, action: #selector(RegisterButtonPress), for: .touchUpInside)
        self.RegisterButton.addTarget(self, action: #selector(DuringButtonPress), for: .touchDown)
        self.navigationItem.title = "Register"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func loadView() {
        let view = RegisterView()
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)

        self.view = view
    }
    
    unowned var MainView: RegisterView { return self.view as! RegisterView }
    unowned var Username: UITextField { return MainView.Username }
    unowned var Password: UITextField { return MainView.Password }
    unowned var RetypePassword: UITextField { return MainView.RetypePassword }
    unowned var RegisterButton: UIButton { return MainView.RegisterButton }
    unowned var StatusLabel: UILabel { return MainView.StatusLabel }
    
    func runRegister(_ username: String, _ password: String, _ retypePassword: String) -> String {
        var result = ""
        let semaphore = DispatchSemaphore(value: 0)
        Register(username, password, retypePassword) { output in
            result = output
            semaphore.signal()
        }
        semaphore.wait()
        if result == "Error" {
            return "Status: Error"
        }
        let jsonData = result.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let Data = dictionary as? [String: String] {
            if Data["message"] == "Created" {
                return "Status: Account Created"
            } else {
                return "Status: " + Data["error_type"]! + "-" + Data["error_message"]!
            }
        }
        return ""
    }
    
    @objc func RegisterButtonPress() {
        StatusLabel.text = "Status: Creating Account"
        let username = Username.text!
        let password = Password.text!
        let retypePassword = RetypePassword.text!
        DispatchQueue.global(qos: .background).async {
            let val = self.runRegister(username, password, retypePassword)
            DispatchQueue.main.async {
                self.StatusLabel.text = val
                self.RegisterButton.backgroundColor = .systemBlue
                self.Password.text = ""
                self.RetypePassword.text = ""
            }
        }
        //RegisterButton.backgroundColor = .systemBlue
    }
    
    @objc func Tapped() {
        // Get out of textbox
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        RetypePassword.resignFirstResponder()
    }
    
    @objc func DuringButtonPress() {
        RegisterButton.backgroundColor = .gray
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Push up textbox when keyboard shows up
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if RetypePassword.isEditing {
                    self.view.frame.origin.y -= 5*(keyboardSize.height) / 8
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Put textbox in original position when keyboard gone
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
