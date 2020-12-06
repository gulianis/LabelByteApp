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
        sleep(2)
        dismiss(animated: true, completion: nil)
    }
    

    unowned var MainView: SuccessView { return self.view as! SuccessView }
    unowned var Label: UILabel { return MainView.Label }

}
