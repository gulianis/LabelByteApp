//
//  LoginViewController.swift
//  LabelByte
//
//  Created by Sachin Guliani on 6/19/20.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoginButton.addTarget(self, action: #selector(LoginButtonPress), for: .touchUpInside)
        self.LoginButton.addTarget(self, action: #selector(DuringLoginButtonPress), for: .touchDown)
        self.RegisterButton.addTarget(self, action: #selector(RegisterButtonPress), for: .touchUpInside)
        self.RegisterButton.addTarget(self, action: #selector(DuringRegisterButtonPress), for: .touchDown)
        // Detect Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        // Make sure screen goes to normal before appearing
        // if keyboard still occuring in login screen
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
        let largest = max(self.view.frame.width, self.view.frame.height)
        if largest < 600 {
            TotalStackView.spacing = 35
            LoginLabelInfo.font = UIFont.systemFont(ofSize: 15.0)
            //LinkLabelInfo.font = UIFont.systemFont(ofSize: 13.0)
            TitleLabelInfo.font = UIFont(name: "Gill Sans", size: 50)
        }
        /*
        if self.view.frame.width < self.view.frame.height {
            print("HERe")
            if self.view.frame.height < 600 {
                TotalStackView.spacing = 35
                LoginLabelInfo.font = UIFont.systemFont(ofSize: 15.0)
                LinkLabelInfo.font = UIFont.systemFont(ofSize: 13.0)
                TitleLabelInfo.font = UIFont(name: "Gill Sans", size: 50)
            }
        } else {
            print("THERE")
            print(self.view.frame.height)
            if self.view.frame.height < 330 {
                TotalStackView.spacing = 35
                LoginLabelInfo.font = UIFont.systemFont(ofSize: 15.0)
                LinkLabelInfo.font = UIFont.systemFont(ofSize: 13.0)
                TitleLabelInfo.font = UIFont(name: "Gill Sans", size: 50)
            }
        }
        */
    }
        
    override func loadView() {
        let view = LoginView()
        view.backgroundColor = .white
            
        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)

        self.view = view
    }
        
    unowned var MainView: LoginView { return self.view as! LoginView }
    unowned var Username: UITextField { return MainView.EmailInfo }
    unowned var Password: UITextField { return MainView.PasswordInfo }
    unowned var LoginButton: UIButton { return MainView.LoginButtonInfo }
    unowned var TotalStackView: UIStackView { return MainView.TotalStackView }
    unowned var LoginLabelInfo: UILabel { return MainView.LoginLabelInfo }
    unowned var RegisterButton: UIButton { return MainView.RegisterButtonInfo }
    unowned var TitleLabelInfo: UILabel { return MainView.TitleLabelInfo }

    func GetToken(_ username: String, _ password: String) -> String {
        // Gets Token from server
        var DictString = ""
        var tokenResult = "error"
        // Uses semaphore to wait for network call till data recieved
        let semaphore = DispatchSemaphore(value: 0)
        ReceiveToken(Username.text!, Password.text!) { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        // Converts and parses data
        let jsonData = DictString.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let tokenDictionary = dictionary as? [String: Any] {
            if let token = tokenDictionary["token"] as? String {
                tokenResult = token
            }
        }
        return tokenResult
    }
        
    @objc func Tapped() {
        // Get out of textbox
        Username.resignFirstResponder()
        Password.resignFirstResponder()
    }
    
    @objc func RegisterButtonPress() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
        RegisterButton.backgroundColor = .systemBlue
    }
            
    @objc func LoginButtonPress() {
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        let token = GetToken(Username.text!, Password.text!)
        // Get token from server
        if token != "error" {
            // Save Token using KeyChain to Encrypt
            let data = KeyChain.convertStrToNSData(string: token)
            KeyChain.save(key: Username.text!, data: data)
            currentUsername = Username.text!
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
            let predicate = NSPredicate(format: "username = %@", Username.text!)
            request.predicate = predicate
            do {
                let results = try context.fetch(request)
                let VC = FileTableViewController()
                // Only save if account has not been used before
                switch (results.count) {
                    case 0:
                        let account = Account(context: context)
                        account.username = Username.text!
                        VC.account = account
                        save()
                    default:
                        VC.account = (results[0] as! Account)
                }
                Username.text = ""
                Password.text = ""
                self.view.frame.origin.y = 0
                self.navigationController?.pushViewController(VC, animated: true)
            }
            catch {
                print("Failed")
            }
        }
        LoginButton.backgroundColor = .systemBlue
    }
        
    @objc func DuringLoginButtonPress() {
        LoginButton.backgroundColor = .gray
    }
    
    @objc func DuringRegisterButtonPress() {
        RegisterButton.backgroundColor = .gray
    }
        
    @objc func keyboardWillShow(notification: NSNotification) {
        // Push up textbox when keyboard shows up
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 3*(keyboardSize.height) / 4
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

    


