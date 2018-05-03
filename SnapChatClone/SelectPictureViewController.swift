//
//  SelectPictureViewController.swift
//  SnapChatClone
//
//  Created by Dean Lindsey on 30/04/2018.
//  Copyright © 2018 Dean Lindsey. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
    }
    
    @IBAction func selectPhotoTapped(_ sender: Any) {
        
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
            imageAdded = true
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        if imagePicker != nil {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        //DELETE THIS WHEN IN PRODUCTION
        //messageTextField.text = "test"
        //imageAdded = true
        
        if let message = messageTextField.text {
            if imageAdded && message != "" {
                //Upload Image
                
                let imageFolder = FIRStorage.storage().reference().child("images")
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                        imageFolder.child(imageName).put(imageData, metadata: nil) { (metadata, error) in
                            
                            if let error = error {
                                self.presentAlert(alert: error.localizedDescription)
                            } else {
                                //Perform Segue
                                if let downloadURL = metadata?.downloadURL()?.absoluteString {
                                    self.performSegue(withIdentifier: "selectReceiverSegue", sender: downloadURL)
                                }
                            }
                        }
                    }
                }
            } else {
                presentAlert(alert: "You must provide an Image and a Message in your snap.")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecipientTableViewController {
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
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
