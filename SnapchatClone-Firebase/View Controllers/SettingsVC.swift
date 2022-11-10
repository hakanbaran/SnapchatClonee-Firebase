//
//  SettingsVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 5.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsVC: UIViewController {

    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var userEmailText: UILabel!
    
    let fireStoreDatabase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getUserInfo()
        
        

        
    }
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapShot, error1 in
            if error1 != nil {
                print("error1")
            } else {
                if snapShot?.isEmpty == false && snapShot != nil {
                    for document in snapShot!.documents {
                        
                        if var username = document.get("username") as? String {
                            username = UserSingleton.sharedUserInfo.username
                            
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            self.userEmailText.text = String(UserSingleton.sharedUserInfo.email)
                            self.usernameText.text = username
                        }
                    }
                }
            }
        }
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
