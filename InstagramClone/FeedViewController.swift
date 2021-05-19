//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by user187672 on 4/30/21.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
   
    var documentIDList = [String]()
    var emailList = [String]()
    var commentList = [String]()
    var imageList = [String]()
    var likeList = [Int]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        getDataFromFirebase()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentIDList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.commentLabel.text=self.commentList[indexPath.row]
        cell.likeCountLabel.text = String(self.likeList[indexPath.row])
        cell.userEmailLabel.text = self.emailList[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string:self.imageList[indexPath.row]))
        cell.documentIdLabel.text = self.documentIDList[indexPath.row]
        return cell
    }
    
    func clearData(){
        emailList.removeAll(keepingCapacity: false)
        commentList.removeAll(keepingCapacity: false)
        imageList.removeAll(keepingCapacity: false)
        likeList.removeAll(keepingCapacity: false)
        documentIDList.removeAll(keepingCapacity: false)
    }
    
    func getDataFromFirebase(){
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                if snapshot != nil && snapshot?.isEmpty != true{
                    self.clearData()
                    for document in snapshot!.documents{
                        
                        self.documentIDList.append(document.documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.emailList.append(postedBy)
                        }
                        if let comment = document.get("postComment") as? String{
                            self.commentList.append(comment)
                        }
                        if let imageURL = document.get("imageURL") as? String{
                            self.imageList.append(imageURL)
                        }
                        if let likeCount = document.get("likes") as? Int{
                            self.likeList.append(likeCount)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }


}
