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
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.navigationItem.hidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    // unowned var Button: UIButton { return MainView.ButtonInfo }
    unowned var MainView: LoginView { return self.view as! LoginView }
    unowned var Username: UITextField { return MainView.EmailInfo }
    unowned var Password: UITextField { return MainView.PasswordInfo }
    unowned var LoginButton: UIButton { return MainView.LoginButtonInfo }
    
    func save() {
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }

    func GetToken(_ username: String, _ password: String) -> String {
        var DictString = ""
        var tokenResult = "error"
        let semaphore = DispatchSemaphore(value: 0)
        ReceiveToken(Username.text!, Password.text!) { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
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
        Username.resignFirstResponder()
        Password.resignFirstResponder()
    }
        
    @objc func ButtonPress() {
        print("YESSSESS")
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        let token = GetToken(Username.text!, Password.text!)
        //print(token)
        if token != "error" {
            let data = KeyChain.convertStrToNSData(string: token)
            KeyChain.save(key: Username.text!, data: data as! NSData)
            currentUsername = Username.text!
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
            let predicate = NSPredicate(format: "username = %@", Username.text!)
            request.predicate = predicate
            do {
                let results = try context.fetch(request)
                let VC = FileTableViewController()
                switch (results.count) {
                    case 0:
                        let account = Account(context: context)
                        account.username = Username.text!
                        VC.account = account
                        save()
                    default:
                        VC.account = results[0] as! Account
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 3*(keyboardSize.height) / 4
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

    


