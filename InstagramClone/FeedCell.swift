//
//  FeedCell.swift
//  InstagramClone
//
//  Created by user187672 on 5/14/21.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onPressedLikeButton(_ sender: Any) {
        
        let likeCount = Int(likeCountLabel.text!)
        
        let firestore = Firestore.firestore()
        
        let data = ["likes": likeCount! + 1] as [String : Any]
        
        firestore.collection("Posts").document(documentIdLabel.text!).setData(data, merge: true)
    }

}
