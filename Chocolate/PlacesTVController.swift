//
//  ViewController.swift
//  YelpApiProject
//
//  Created by AT on 12/2/16.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesTVController: UITableViewController {
    
    var places = [PlaceInformation]()
    var placesGetter = PlacesGetter()
    var PLACE_DETAIL_LOAD_SEGUE = "PlaceDetailLoadSegue"
    var rootLatitude:String!
    var rootLongitude:String!
    var placesTVControllerRootLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nearby Places"
        
        func updatePlaces(inPlaces:[PlaceInformation]){
            places = inPlaces
            var indexPaths = [IndexPath]()
            var itemPos = 0
            for _ in inPlaces{
                let index = itemPos
                let indexPath = IndexPath(row: index, section: 0)
                indexPaths.append(indexPath)
                itemPos += 1
                //print("Place name is \(eachPlace.name)")
            }
            if places.count > 0{
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
            
        }
//        print("Root latitude is \(rootLatitude)")
//        print("Root longitude is \(rootLongitude)")
        print("PlacesTVControllerRootLocation in PlacesTVController is \(placesTVControllerRootLocation)")
        placesGetter.getPlaces(latitude: String(Int(placesTVControllerRootLocation.coordinate.latitude)), longitude: String(Int(placesTVControllerRootLocation.coordinate.longitude)), completionListener: updatePlaces)
        //placesGetter.getPlaces(latitude: rootLatitude, longitude: rootLongitude, completionListener: updatePlaces)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceItemCell") as! PlaceItemCell
        //print("Long is \(long) Lat is \(lat)")
        cell.PlaceName.text = places[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return places.count
        }
        return 0
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PLACE_DETAIL_LOAD_SEGUE{
            let indexPath = tableView.indexPathForSelectedRow
            let selectedPlaceInfo = places[(indexPath?.row)!]
            let destinationViewController = segue.destination as? PlaceDetailViewController
            destinationViewController?.currentPlaceInfo = selectedPlaceInfo
            destinationViewController?.PlaceLatitude = String(Int(placesTVControllerRootLocation.coordinate.latitude))
            destinationViewController?.PlaceLongitude = String(Int(placesTVControllerRootLocation.coordinate.longitude))
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: PLACE_DETAIL_LOAD_SEGUE, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

