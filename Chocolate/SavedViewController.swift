//
//  SavedViewController.swift
//  Chocolate
//
//  Created by AT on 12/5/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import Firebase

class SavedViewController: UITableViewController {

    @IBOutlet weak var ItemCell: UITableViewCell!
    @IBOutlet var table: UITableView!
    
    var allAddressInView: [String:AnyObject]!
    var outputAddress: [String:AnyObject]!
    
    var item:[String] = []
    var address:String = ""
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.estimatedRowHeight = 56
        //tableView.reloadData()
        //ListOfAdress(items: item)
    }
    override func viewWillAppear(_ animated: Bool) {
        ListOfAdress(items: item)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.item)
        return self.count
    }
    
    //IBAction for "Add" button
    
//        @IBAction func addNewItem(_ button: UIBarButtonItem) {
//            //let newItem = ItemCell.createItem()
//    
//            if let index = ItemCell.allItems.index(of: addNewItem) {
//                let indexPath = IndexPath(row: index, section: 0)
//                tableView.insertRows(at: [indexPath], with: .automatic)
//            }
//        }
    
    //IBAction for "Edit" button
    
    
    
    func m2(_ button: UIBarButtonItem) {
        if isEditing {
            setEditing(false, animated: true)
            //button.setTitle("Edit", for: UIControlState())
        }
        else {
            setEditing(true, animated: true)
            //button.setTitle("Done", for: UIControlState())
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //print("Trying to delete Section: \(indexPath.section) Row: \(indexPath.row)")
            // let item = itemStore.allItems[indexPath.row]
            
            //            let title = "Delete \(item.name)?"
            //
            let message = "Are you sure?"
            //
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            //
            //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            //
            //            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive,
                                             handler: {_ in
                                                //                                                self.itemStore.removeItem(item)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
            
            
            count = count-1
        }
    }
    
    
    
    
    func ListOfAdress(items:Array<String>) -> Void{
        
        let localItem:[String] = []
        let userID = (FIRAuth.auth()?.currentUser?.uid)!
        
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child(userID).observeSingleEvent(of: .value, with: {  snapshot in
            
            if let dictionary: [String:AnyObject] = snapshot.value as? [String: AnyObject] {
                print("Dictionary is \(dictionary)")
                print("after dictionay")
                
                if let addressDictionary = dictionary["Address"] as? [String: AnyObject] {
                    
                    self.allAddressInView = addressDictionary
                    
                    if let photos = addressDictionary["home"] as? [String: AnyObject] {
                        //let photosArray = photos["photo"] as? [[String: AnyObject]] {
                        print("Photos are \(photos)")
                    }
                    for (kind, numbers) in addressDictionary {
                        print("Kind: \(kind)")
                        self.item.append(kind)
                    }
                }
                
                //self.address = (dictionary["Address"] as? String)!
                print(self.address)
                
                //self.item.append(self.address as String)
                //
                print("test")
                print("local is \(localItem)")
                //self.table.reloadData()
            }
        },withCancel: nil)
        
        
        //        ref.child("Users").child(userID).queryOrderedByChild("Address").queryEqualToValue(sport)
        //            .observeEventType(.Value, withBlock: { snapshot in
        //                for child in snapshot.children {
        //                    let name = child.value["Name"] as! NSString
        //                    //   let idofuser = ref.childByAutoId() as! NSString
        //                    //    print(idofuser)
        //                    self.item.append(name as String)
        //                    //  self.id.append(idofuser as String)
        //                }
        //                dispatch_async(dispatch_get_main_queue(), {
        //                    self.ListTable.reloadData()
        //                })
        //                print(self.item)
        //                //   print(<#T##items: Any...##Any#>)
        //                print(self.self.item.count)
        //
        //            })
        //        // self.printArray()
        self.item = localItem
        self.count = items.count
        print(self.item)
        print("Item is \(self.item)")
        return
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let selectedRow = item[indexPath.row]
    //        outputAddress = allAddressInView[selectedRow] as? [String: AnyObject]
    //        print("Passable data is \(outputAddress)")
    //        performSegue(withIdentifier: "detailsSegue", sender: self)
    //
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // let cell = sender as! CustomCell
        let indexPath = tableView.indexPathForSelectedRow
        let selectedRow = item[(indexPath?.row)!]
        outputAddress = allAddressInView[selectedRow] as? [String: AnyObject]
        let detailController = segue.destination as! SaveViewController
        detailController.inputAddress = outputAddress
        print("Output Address is \(outputAddress)")
        detailController.LocationName = outputAddress["LocationName"] as? String
        detailController.LocationAddressLine1 = outputAddress["LocationAddressLine1"] as? String
        
        detailController.LocationAddressLine2 = outputAddress["LocationAddressLine2"] as? String
        
        detailController.LocationAddressLine3 = outputAddress["LocationAddressLine3"] as? String
        
        //        if segue.identifier == "detailsSegue" {
        //                let detailController = segue.destination as! TestViewController
        //                detailController.inputAddress = outputAddress
        //        }
    }
    
    // table cell value
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ItemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")! as! SavedViewTableCell
        ItemCell.NameLabel.text = item[indexPath.row]
        
        // cell.textLabel?.text = self.item[indexPath.row]
        // cell.accessoryType = UItableviewcella
        
        
        return ItemCell
        
    }
}

