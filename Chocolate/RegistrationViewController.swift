//
//  RegistrationViewController.swift
//  Chocolate
//
//  Created by AT on 12/6/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    var databaseReference:FIRDatabaseReference!
    var storageReference:FIRStorageReference!
    let profilePicName = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = FIRDatabase.database().reference()
        storageReference = FIRStorage.storage().reference().child("\(profilePicName).png")
        profilePicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profilePicView.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func actionToBePerformed(withIdentifierProvided: String)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: withIdentifierProvided)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func alertMessageToBeDisplayed(messageToBeDisplayed: String)
    {
        let alertController = UIAlertController(title: "OOPs !", message: messageToBeDisplayed , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func userIsCreated()
    {
        FIRAuth.auth()?.createUser(withEmail: self.userEmailTextField.text!, password: self.userPasswordTextField.text!, completion: {(user, error)
            in
            if error == nil
            {
                self.actionToBePerformed(withIdentifierProvided: "loginpage")
                
                /* alertMessageToBeDisplayed(messageToBeDisplayed: "Welcome to the Family") */
                
                let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
                
                if  let uploadData = UIImagePNGRepresentation(self.profilePicView.image!)
                {
                    self.storageReference.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil
                        {
                            print (error!)
                            return
                        }
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        {
                            let values = ["Username": self.userNameTextField.text!,
                                          "ProfilePicURL": profileImageUrl] as [String : Any]
                            self.databaseReference.child("Users").child(userID).setValue(values)
                        }
                        
                    })
                }
            }
            else
            {
                self.alertMessageToBeDisplayed(messageToBeDisplayed: (error?.localizedDescription)!)
            }
        })
    }
    
    func handleSelectProfileImageView()
    {
        print("Imageselected")
        let profileDpPicker = UIImagePickerController()
        profileDpPicker.delegate = self
        profileDpPicker.allowsEditing = true
        present(profileDpPicker,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        var selectedImageForProfilePic:UIImage?
        
        if let editedImageForDisplay = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageForProfilePic = editedImageForDisplay
        }
        else if let originalImageForDisplay = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageForProfilePic = originalImageForDisplay
        }
        
        if let imageSelectedForDisplay = selectedImageForProfilePic
        {
            profilePicView.image = imageSelectedForDisplay
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userTappedTheBackground(_ sender: UITapGestureRecognizer) {
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        userEmailTextField.resignFirstResponder()
        userRepeatPasswordTextField.resignFirstResponder()
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        let userName = userNameTextField.text
        let emailId = userEmailTextField.text
        let password = userPasswordTextField.text
        let repeatPassword = userRepeatPasswordTextField.text
        
        if((userName?.isEmpty)! || (emailId?.isEmpty)! || (password?.isEmpty)! || (repeatPassword?.isEmpty)!)
        {
            alertMessageToBeDisplayed(messageToBeDisplayed: "You Forgot to Enter all the Field")
        }
        
        if((!(userName?.isEmpty)!) || !((emailId?.isEmpty)!) || !((password?.isEmpty)!) || !((repeatPassword?.isEmpty)!))
        {
            if(password != repeatPassword)
            {
                alertMessageToBeDisplayed(messageToBeDisplayed: "The Password and Re Entered Password does not Match")
            }
            else
            {
                userIsCreated()
                
            }
        }
    }
    
    @IBAction func existingAccountButton(_ sender: UIButton) {
        actionToBePerformed(withIdentifierProvided: "loginpage")
    }
}
