//
//  ProfileViewController.swift
//  Chocolate
//
//  Created by AT on 12/5/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePic: UIView!
    @IBOutlet weak var userNameProfileScreen: UILabel!
    var databaseReferenceForProfile:FIRDatabaseReference!
    var storageReferenceForProfile:FIRStorageReference!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        databaseReferenceForProfile = FIRDatabase.database().reference()
        storageReferenceForProfile = FIRStorage.storage().reference().child("profilePic")
        userNameLoading()
        userProfilePicLoading()
        profilePicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profilePicImageView.isUserInteractionEnabled = true
    }
    
    func userNameLoading()
    {
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        self.databaseReferenceForProfile.child("Users").child(userID).observeSingleEvent(of: .value, with: {(FIRDataSnapshot)
            in
            if let dic  = FIRDataSnapshot.value as? [String: AnyObject]
            {
                self.userNameProfileScreen.text = dic["Username"] as? String
            }
        }, withCancel: nil)
    }
    
    func userProfilePicLoading()
    {
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        self.databaseReferenceForProfile.child("Users").child(userID).observeSingleEvent(of: .value, with: {(FIRDataSnapshot)
            in
            if let dic  = FIRDataSnapshot.value as? [String: AnyObject]
            {
                if let profilePicImageViewUrl = dic["ProfilePicURL"] as? String
                {
                    let url = URL(string: profilePicImageViewUrl)
                    URLSession.shared.dataTask(with: url!,
                                               completionHandler:
                        {
                            (data,response,error) in
                            if error != nil
                            {
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async
                                {
                                    self.profilePicImageView.image = UIImage(data: data!)
                            }
                    }).resume()
                    
                }
            }
        }, withCancel: nil)
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
            profilePicImageView.image = imageSelectedForDisplay
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func profilePicChange()
    {
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        
        if  let uploadData = UIImagePNGRepresentation(self.profilePicImageView.image!)
        {
            self.storageReferenceForProfile.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil
                {
                    print (error!)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString
                {
                    let values = ["Username": self.userNameProfileScreen.text!,
                                  "ProfilePicURL": profileImageUrl] as [String : Any]
                    self.databaseReferenceForProfile.child("Users").child(userID).setValue(values)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginpage")
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
}
