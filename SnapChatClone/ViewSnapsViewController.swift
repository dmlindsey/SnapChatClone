//
//  ViewSnapsViewController.swift
//  SnapChatClone
//
//  Created by Dean Lindsey on 03/05/2018.
//  Copyright © 2018 Dean Lindsey. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ViewSnapsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var snap : FIRDataSnapshot?
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURL = snapDictionary["imageURL"] as? String {
                    
                    messageLabel.text = description
                    
                    if let url = URL(string: imageURL) {
                        imageView.sd_setImage(with: url)
                    }
                    
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let currentUserUID = FIRAuth.auth()?.currentUser?.uid {
            if let key = snap?.key {
                FIRDatabase.database().reference().child("users").child(currentUserUID).child("snaps").child(key).removeValue()
                FIRStorage.storage().reference().child("images").child(imageName).delete(completion: nil)
            }
        }
    }
}
