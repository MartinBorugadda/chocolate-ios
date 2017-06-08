//
//  NewLocationToBeSavedViewController.swift
//  Chocolate
//
//  Created by AT on 12/6/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import Firebase

class NewLocationToBeSavedViewController: UIViewController {
    @IBOutlet weak var newLocationName: UITextField!
    @IBOutlet weak var newLocationAddressLine1: UITextField!
    @IBOutlet weak var newLocationAddressLine2: UITextField!
    @IBOutlet weak var newLocationAddressLine3: UITextField!
    
    var databaseReference:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = FIRDatabase.database().reference()
        navigationItem.title = "New Saved Location"
        saveButtonOnNavigationItem()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveButtonOnNavigationItem()
    {
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(NewLocationToBeSavedViewController.saveTheDataWritten))
        self.navigationItem.rightBarButtonItem = save
    }
    
    func saveTheDataWritten()
    {
        print("saved")
        if((!(newLocationName.text?.isEmpty)!) && ((!(newLocationAddressLine1.text?.isEmpty)!) || (!(newLocationAddressLine2.text?.isEmpty)!) || (!(newLocationAddressLine3.text?.isEmpty)!)))
        {
            userFavoriteLocationSavedToDataBase()
            actionToBePerformed(withIdentifierProvided: "homepage")
        }
        else
        {
            alertMessageToBeDisplayed(messageToBeDisplayed: "Please Enter the complete details to save the Location")
        }
    }
    
    func userFavoriteLocationSavedToDataBase()
    {
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        let values = ["LocationName": self.newLocationName.text!,
                      "LocationAddressLine1": self.newLocationAddressLine1.text!,
                      "LocationAddressLine2": self.newLocationAddressLine2.text!,
                      "LocationAddressLine3": self.newLocationAddressLine3.text!]
        self.databaseReference.child("Users").child(userID).child("Address").child(self.newLocationName.text!).setValue(values)
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
    
}
