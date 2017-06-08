//
//  LoginViewController.swift
//  Chocolate
//
//  Created by AT on 12/6/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        isUserAlreadyLoggedIn()
    }
    
    func isUserAlreadyLoggedIn()
    {
        if (FIRAuth.auth()?.currentUser) != nil
        {
            actionToBePerformed(withIdentifierProvided: "homepage")
        }
        else
        {
            return
        }
    }
    
    func ifUserClickedRegisterButton()
    {
        actionToBePerformed(withIdentifierProvided: "signup")
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
    
    func userRegisteredForFirstTime()
    {
        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user,error) in
            if error == nil
            {
                self.actionToBePerformed(withIdentifierProvided: "homepage")
            }
            else
            {
                self.alertMessageToBeDisplayed(messageToBeDisplayed: (error?.localizedDescription)!)
            }
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func userTappedTheBackground(_ gestureRecognizer: UITapGestureRecognizer)
    {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func loginAction(_ sender: UIButton)
    {
        if(emailTextField.text == "" || passwordTextField.text == "")
        {
            alertMessageToBeDisplayed(messageToBeDisplayed: "You Forgot to Enter all the Details")
        }
        else
        {
            userRegisteredForFirstTime()
        }
    }
    
    @IBAction func registrationAction(_: UIButton)
    {
        ifUserClickedRegisterButton()
    }
    
}
