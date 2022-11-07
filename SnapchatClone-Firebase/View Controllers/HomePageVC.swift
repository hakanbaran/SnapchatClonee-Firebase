//
//  HomePageVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 5.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class HomePageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    
    var snapArray = [Snap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getUserInfo()
    }
    
    
    func getSnapFromFirebase() {
        
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapShot, error2 in
            if error2 != nil {
                self.makeAlert(titleInput: "Error!!!", messageInput: error2?.localizedDescription ?? "Error!")
            } else {
                
                if snapShot?.isEmpty == false && snapShot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapShot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let ImageUrlArray = document.get("ImageUrlArray") as? [String] {
                                if let date = document.get("Date") as? Timestamp {
                                    
                                    if let different = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if different >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete()
                                        } else {
                                            // TimeLeft ->  SnapVC
                                        }
                                    }
                                    
                                    
                                    let snap = Snap(username: username, imageUrlArray: ImageUrlArray, date: date.dateValue())
                                    
                                    self.snapArray.append(snap)
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        
    }
    
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapShot, error1 in
            if error1 != nil {
                self.makeAlert(titleInput: "Error!!!", messageInput: error1?.localizedDescription ?? "Error!")
                
            } else {
                
                if snapShot?.isEmpty == false && snapShot != nil {
                    
                    for document in snapShot!.documents {
                        
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                        
                        
                    }
                }
                
                
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellVC
        cell.snapUsernameLabel.text = snapArray[indexPath.row].username
        
        return cell
    }
    

    func makeAlert(titleInput : String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    

}
