//
//  ViewController.swift
//  InstagramClone
//
//  Created by user187672 on 4/28/21.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signInClicked(_ sender: Any) {
        
        if areFieldsNotEmpty(){
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authData, error) in
                if error != nil{
                    self.showAlert(title: "Error!", desc: error?.localizedDescription ?? "Something went wrong")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else{
            self.showAlert(title: "Error!", desc: "Please enter blank fields")
        }
        
    }
    
    func areFieldsNotEmpty()->Bool{
        if emailTextField.text != "" && passwordTextField.text != ""{
            return true
        }
        return false
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if areFieldsNotEmpty(){
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil{
                    self.showAlert(title: "Error!", desc: error?.localizedDescription ?? "Something went wrong")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }}
        }else{
            self.showAlert(title: "Error!", desc: "Please enter blank fields")
        }
        
      
    }
    
    func showAlert(title:String, desc: String){
        let alert = UIAlertController(title: title, message: desc, preferredStyle: UIAlertController.Style.alert)
            let okButton  = UIAlertAction(title: "OK"
                                          , style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

