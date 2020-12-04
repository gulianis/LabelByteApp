//
//  SuccessViewController.swift
//  try
//
//  Created by Sachin Guliani on 9/1/20.
//

import UIKit

class SuccessViewController: UIViewController {
    
    var message = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //definesPresentationContext = true

        switch (message) {
            case "Success":
                Label.text = "Saved"
            case "Reached Access Limit":
                Label.text = "Reached \nAccess \nLimit"
            case "Blocked 300 Seconds":
                Label.text = "Blocked \n5 \nMinutes"
            default:
                Label.text = "Error"
        }
    }
    
    override func loadView() {
        let view = SuccessView()

        self.view = view
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        print(UIApplication.topViewController()!)
        if UIApplication.topViewController()! == SuccessViewController() {
            print("IT IS SUCCESS VIEW CONTROLLER")
        }
        */

        sleep(2)
        dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        //UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        /*
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }else{
            print("navigationController is nil")
        }
        */
       // delegate?.isDisplaying = false
    }
    

    unowned var MainView: SuccessView { return self.view as! SuccessView }
    unowned var Label: UILabel { return MainView.Label }

}
