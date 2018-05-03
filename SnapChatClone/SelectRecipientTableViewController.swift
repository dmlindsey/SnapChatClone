//
//  SelectRecipientTableViewController.swift
//  SnapChatClone
//
//  Created by Dean Lindsey on 01/05/2018.
//  Copyright © 2018 Dean Lindsey. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SelectRecipientTableViewController: UITableViewController {
    
    var downloadURL = ""
    var imageName = ""
    var snapDescription = ""
    var users : [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let user = Users()
            
            if let userDictonary = snapshot.value as? NSDictionary {
                if let email = userDictonary["email"] as? String {
                    user.email = email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        if let fromEmail =  FIRAuth.auth()?.currentUser?.email {
            let snap = ["from": fromEmail, "description": snapDescription, "imageURL": downloadURL, "imageName": imageName]
            FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

class Users {
    
    var email = ""
    var uid = ""
    
}
