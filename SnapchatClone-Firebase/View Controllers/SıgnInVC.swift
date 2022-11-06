//
//  ViewController.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 4.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SıgnInVC: UIViewController {

    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result1, error3 in
                if error3 != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error3?.localizedDescription ?? "ERROR!!")
                } else {
                    
                    self.performSegue(withIdentifier: "toHomepageVC", sender: nil)
                    
                }
            }
            
            
        } else {
            
            self.makeAlert(titleInput: "ERROR!", messageInput: "Email/Password ???")
            
        }
        
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error1 in
                if error1 != nil {
                    
                    self.makeAlert(titleInput: "ERROR!!", messageInput: error1?.localizedDescription ?? "ERROR!!!")
                    
                } else {
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email:" : self.emailText.text!, "username": self.usernameText.text!] as [String : Any]
                    
                    fireStore.collection("userInfo").addDocument(data: userDictionary) { error2 in
                        if error2 != nil {
                            self.makeAlert(titleInput: "ERROR!!!", messageInput: "ERROR!!!")
                        }
                    }
                    self.performSegue(withIdentifier: "toHomepageVC", sender: nil)
                }
            }
            
            
        } else {
            
            self.makeAlert(titleInput: "ERROR!!!!", messageInput: "Username/Email/Password ???")
        }
        
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
}

