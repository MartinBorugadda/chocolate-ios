//
//  SaveViewController.swift
//  Chocolate
//
//  Created by AT on 12/6/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressOneLabel: UILabel!
    @IBOutlet weak var addressThreeLabel: UILabel!
    
    var inputAddress: [String:AnyObject]!
    
    var LocationName:String!
    
    var LocationAddressLine1:String!
    
    var LocationAddressLine2:String!
    
    var LocationAddressLine3:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        navigationItem.title = "Address Details"
        // Do any additional setup after loading the view.
    }
    
    func updateLabels(){
        //print("Input address is \(inputAddress)")
        //        nameLabel.text = inputAddress["LocationName"] as? String
        //        addressOneLabel.text = inputAddress["LocationAddressLine1"] as? String
        //        addressTwoLabel.text = inputAddress["LocationAddressLine2"] as? String
        //        addressThreeLabel.text = inputAddress["LocationAddressLine3"] as? String
        
        nameLabel.text = LocationName
        addressOneLabel.text = LocationAddressLine1
        addressTwoLabel.text = LocationAddressLine2
        addressThreeLabel.text = LocationAddressLine3
    }
    
    @IBOutlet weak var addressTwoLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
