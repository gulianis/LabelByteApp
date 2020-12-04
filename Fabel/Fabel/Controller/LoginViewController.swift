//
//  LoginViewController.swift
//  try
//
//  Created by Sachin Guliani on 6/19/20.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.LoginButton.addTarget(self, action: #selector(ButtonPress), for: .touchUpInside)
        self.LoginButton.addTarget(self, action: #selector(DuringButtonPress), for: .touchDown)
        // Detect Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make sure screen goes to normal before appearing
        // if keyboard still occuring in login screen
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
    
    func save() {
        // Save to Core Data
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }


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
        
    @objc func ButtonPress() {
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
                self.navigationController?.pushViewController(VC, animated: true)
            }
            catch {
                print("Failed")
            }
        }
        LoginButton.backgroundColor = .systemBlue
    }
    
    @objc func DuringButtonPress() {
        LoginButton.backgroundColor = .gray
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

    


