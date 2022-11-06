//
//  SettingsVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 5.11.2022.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        self.performSegue(withIdentifier: "toSignInVC", sender: nil)
            
        } catch {
            print("Error1")
            
        }
            
            
            
            
        
    }
    
    

}
