//
//  HomePageVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 5.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage


class HomePageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    
    var snapArray = [Snap]()
    
    var chosenSnap : Snap?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserInfo()
        getSnapFromFirebase()
        
        print(snapArray.count)

        
    }
    
    
    func getSnapFromFirebase() {
        
        fireStoreDatabase.collection("Snaps").order(by: "Date", descending: true).addSnapshotListener { snapShot, error2 in
            if error2 != nil {
                self.makeAlert(titleInput: "Error!!!", messageInput: error2?.localizedDescription ?? "Error!")
            } else {
                
                if snapShot?.isEmpty == false && snapShot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    print("Control1")
                    
                    for document in snapShot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let ImageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("Date") as? Timestamp {
                                    
                                    if let different = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if different >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete()
                                        } else {
                                            
                                            let snap = Snap(username: username, imageUrlArray: ImageUrlArray, date: date.dateValue(), timeDifference: 24 - different)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        
    }
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments {
            
            (snapshot, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        if snapshot?.isEmpty == false && snapshot != nil {
                            
                            print("baran1")
                            for document in snapshot!.documents {
                                if let username = document.get("username") as? String {
                                    UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                    UserSingleton.sharedUserInfo.username = username
                                    print("Baran")
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
        cell.snapImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        cell.snapUsernameLAbel.text = snapArray[indexPath.row].username
        
        
        print("\(snapArray[indexPath.row].username) deneme111")
        
        return cell
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
