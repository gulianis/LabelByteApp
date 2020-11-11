//
//  SuccessViewController.swift
//  try
//
//  Created by Sandeep Guliani on 9/1/20.
//

import UIKit

class SuccessViewController: UIViewController {
    
    var message = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch (message) {
            case "Success":
                Label.text = "Saved"
            case "Reached Access Limit":
                Label.text = "Reached \nAccess \nLimit"
            case "Blocked 60 Seconds":
                Label.text = "Blocked \n60 \nSeconds"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
