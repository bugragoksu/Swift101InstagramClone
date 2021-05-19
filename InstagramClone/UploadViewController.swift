//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by user187672 on 4/30/21.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        uploadButton.isEnabled = false
        selectImageView.isUserInteractionEnabled = true
        selectImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSelectImage)))
        
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func onTapSelectImage(){
        let pickerController =  UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImageView.image = info[.originalImage] as? UIImage
        uploadButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func onClickedUploadButton(_ sender: Any) {
        let ref = Storage.storage().reference()
        let mediaRef = ref.child("media")
        if let data = selectImageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageRef = mediaRef.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    self.showAlert(title: "Error!", desc: error?.localizedDescription ?? "Something went wrong")
                }else{
                    imageRef.downloadURL { (url, error) in
                        if error == nil {
                           let imageURL = 	url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            let firestorePostsReference = firestoreDatabase.collection("Posts")
                            
                            let data = ["imageURL":imageURL!, "postedBy":Auth.auth().currentUser!.email!, "postComment": self.notesTextField.text!,"date":FieldValue.serverTimestamp(),"likes":0] as [String:Any]
                            
                            firestorePostsReference.addDocument(data: data) { (error) in
                                if error != nil{
                                    self.showAlert(title: "Error!", desc: error?.localizedDescription ?? "Something went wrong")
                                }else{
                                    self.showAlert(title: "Success!", desc: "Your entry posted successfully!")
                                    self.notesTextField.text = ""
                                    self.selectImageView.image = UIImage(named: "select-2")
                                    self.tabBarController?.selectedIndex=0
                                }
                            }
                            
                        }
                    }
                }
            }
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
