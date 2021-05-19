//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by user187672 on 4/30/21.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch  {
            print("error")
        }
        
    }
    

}
