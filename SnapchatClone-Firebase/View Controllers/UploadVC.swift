//
//  UploadVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 5.11.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore



class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImage.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        
        uploadImage.addGestureRecognizer(gestureRecognizer)

        
    }
    
    @objc func imageClicked() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    

    
    @IBAction func uploadClicked(_ sender: Any) {
        
     
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        
        let mediaFolder = storageReferance.child("Media")
        
        if let data = uploadImage.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data) { metaData, error1 in
                if error1 != nil {
                    self.makeAlert(titleInput: "Error!!!", messageInput: error1?.localizedDescription ?? "Error!")
                } else {
                    
                    imageReferance.downloadURL { url, error2 in
                        if error2 == nil {
                            let imageURL = url?.absoluteString
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapShot, error4 in
                                if error4 != nil {
                                    self.makeAlert(titleInput: "Error!!!", messageInput: error4?.localizedDescription ?? "Error!")
                                } else {
                                    if snapShot?.isEmpty == false && snapShot != nil {
                                        for document in snapShot!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageURLArray = document.get("imageUrlArray") as? [String] {
                                                imageURLArray.append(imageURL!)
                                                
                                                let additionalDictionary = ["imageUrlArray": imageURLArray] as [String: Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error5 in
                                                    if error5 == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImage.image = UIImage(named: "camera")
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        let snapDictionary = ["imageUrlArray" : [imageURL!], "snapOwner": UserSingleton.sharedUserInfo.username, "Date": FieldValue.serverTimestamp()] as [ String: Any]
                                        
                                        print("Hakan")
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error3 in
                                            if error3 != nil {
                                                self.makeAlert(titleInput: "Error!!!", messageInput: error3?.localizedDescription ?? "Error!")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImage.image = UIImage(named: "camera")
                                            }
                                        }
                                        
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
        
    
     
     
    
    
    
    func makeAlert(titleInput : String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    

}
