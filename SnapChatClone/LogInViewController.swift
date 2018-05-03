//
//  LogInViewController.swift
//  SnapChatClone
//
//  Created by Dean Lindsey on 30/04/2018.
//  Copyright © 2018 Dean Lindsey. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var topTapped: UIButton!
    
    @IBAction func topTapped(_ sender: Any) {
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                
                if signUpMode {
                    //Sign Up
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            
                            if let user = user {
                                FIRDatabase.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                        }
                    })
                    
                } else {
                    //Log In
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func bottomTapped(_ sender: Any) {
        
        if signUpMode {
            //Switch to Log In
            signUpMode = false
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
        } else {
            //Switch to Sign Up
            signUpMode = true
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}

