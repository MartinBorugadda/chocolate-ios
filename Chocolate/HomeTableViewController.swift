//
//  HomeTableViewController.swift
//  Chocolate
//
//  Created by AT on 11/26/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class HomeTableViewController: UITableViewController{
    
    var currentLocationWeatherGetter = WeatherGetter()
    var destinationWeatherGetter = WeatherGetter()
    
    let locationManager = CLLocationManager()
    
    var rootPresentLocation: CLLocation!
    var rootDestinationLocation:CLLocation!
    
    var passableLatitude:String!
    var passableLongitude:String!
    //let routeControl = RouteViewController()
    
    var incomingDestinationLatitude:Float!
    var incomingDestinationLongitude:Float!
    
    var PassableLocation:CLLocation!
    //var incomingDestinationLocation:CLLocationCoordinate2D!
    
    var databaseReference:FIRDatabaseReference!
    var storageReference:FIRStorageReference!

    var firebaseLatitude:String!
    var firebaseLongitude:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseReference = FIRDatabase.database().reference()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
        }
        rootPresentLocation = locationManager.location
        
        let userDefaults = UserDefaults.standard
        userDefaults.synchronize()
        let incomingDestinationLatitude = userDefaults.float(forKey: "destinationLatitude")
        let incomingDestinationLongitude = userDefaults.float(forKey: "destinationLongitude")
        print("DestinationLatitude from User Data is \(incomingDestinationLatitude)")
        print("DestinationLongitude from User Data is \(incomingDestinationLongitude)")

       
        self.databaseReference.child("Destination").observeSingleEvent(of: .value, with: {(FIRDataSnapshot)
            in
            if let dic  = FIRDataSnapshot.value as? [String: AnyObject]
            {
                self.firebaseLatitude = dic["Latitude"] as? String
                self.firebaseLongitude = dic["Longitude"] as? String
                print("Dictionary is \(dic)")
                print("Firebase Latitude is \(self.firebaseLatitude)")
                print("Firebase Longitude is \(self.firebaseLongitude)")
            }
        }, withCancel: nil)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            print("Firebase latitude in dispatch is \(self.firebaseLatitude)")
            print("Firebase longitude in dispatch is \(self.firebaseLongitude)")
            
            if (incomingDestinationLatitude != 0 && incomingDestinationLongitude != 0){
                self.rootDestinationLocation = CLLocation(latitude: CLLocationDegrees(self.firebaseLatitude)!, longitude: CLLocationDegrees(self.firebaseLongitude)!)
                print("Set root destination location using User Data DestinationLatitude and User Data DestinationLongitude as \(self.rootDestinationLocation)")
            }
            else{
                self.rootDestinationLocation = self.locationManager.location
            }
            
            
            print("Setting PresentLocation in Dispatch ViewDidLoad as \(self.rootPresentLocation)")
            print("Setting DestinationLocation in Dispatch ViewDidLoad as \(self.rootDestinationLocation)")
            self.tableView.reloadData();
            // Your code with delay
        }
//        let time = DispatchTime.now(dispatch_time_t(DispatchTime.now()), 500 * Int64(NSEC_PER_MSEC))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            self.tableview.reloadData();
//        }
        
        print("Firebase latitude is \(firebaseLatitude)")
        print("Firebase longitude is \(firebaseLongitude)")
        
        if (incomingDestinationLatitude != 0 && incomingDestinationLongitude != 0){
            rootDestinationLocation = CLLocation(latitude: CLLocationDegrees(incomingDestinationLatitude), longitude: CLLocationDegrees(incomingDestinationLongitude))
            print("Set root destination location using User Data DestinationLatitude and User Data DestinationLongitude as \(rootDestinationLocation)")
        }
        else{
            rootDestinationLocation = locationManager.location
        }
        
        
        print("Setting PresentLocation in ViewDidLoad as \(rootPresentLocation)")
        print("Setting DestinationLocation in ViewDidLoad as \(rootDestinationLocation)")
        //let sampleCoordinates = locationManager.location?.coordinate
        //print("Sample Coordinates are \(sampleCoordinates)")
        //incomingDestinationLatitude = Int((sampleCoordinates?.latitude)!)
        //incomingDestinationLongitude = Int((sampleCoordinates?.longitude)!)
        // Do any additional setup after loading the view, typically from a nib.
        //incomingDestinationLongitude = (Int)(routeControl.destinationLocationLongitude!)
        //incomingDestinationLatitude = (Int)(routeControl.destinationLocationLattitude!)
    }
    




    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "playerSegue") {
            // initialize new view controller and cast it as your view controller
            let destinationViewController = segue.destination as! PlacesTVController
            destinationViewController.placesTVControllerRootLocation = PassableLocation
            print("Setting placesTVControllerRootLocation as \(PassableLocation)")

            //var viewController = segue.destinationViewController as PlacesTVController
            // your new view controller should have property that will store passed value
            if tableView.indexPathForSelectedRow?.section == 1{
                destinationViewController.rootLatitude = String(rootDestinationLocation.coordinate.latitude)
                destinationViewController.rootLongitude = String(rootDestinationLocation.coordinate.longitude)
                destinationViewController.placesTVControllerRootLocation = rootDestinationLocation
                print("Setting placesTVControllerRootLocation-Destinationas \(rootDestinationLocation)")
                //destinationViewController.placesTVControllerRootLocation = PassableLocation
                //print("Setting placesTVControllerRootLocation-Destinationas \(PassableLocation)")
            }
            if tableView.indexPathForSelectedRow?.section == 2{
                destinationViewController.rootLatitude = String(rootPresentLocation.coordinate.latitude)
                destinationViewController.rootLongitude = String(rootPresentLocation.coordinate.longitude)
                destinationViewController.placesTVControllerRootLocation = rootPresentLocation
                print("Setting placesTVControllerRootLocation-PresentLocation as \(rootPresentLocation)")
                //destinationViewController.placesTVControllerRootLocation = PassableLocation
                //print("Setting placesTVControllerRootLocation-PresentLocation as \(PassableLocation)")
            }
//            destinationViewController.rootLatitude = passableLatitude
//            destinationViewController.rootLongitude = passableLongitude
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
        
            PassableLocation = rootDestinationLocation
            print("Setting passable in destination location as\(PassableLocation)")
            //let destinationTVC = PlacesTVController()
//            print("Adding name as \(String(Int(rootDestinationLocation.coordinate.latitude)))")
//            print("Adding name as \(String(Int(rootDestinationLocation.coordinate.longitude)))")
//            passableLatitude = String(Int(rootDestinationLocation.coordinate.latitude))
//            passableLongitude = String(Int(rootDestinationLocation.coordinate.longitude))
            //performSegue(withIdentifier: "playerSegue", sender: self)
            
        }
            
        else if indexPath.section == 2{
            PassableLocation = rootPresentLocation
            print("Setting passable location in current location as\(PassableLocation)")
            //let destinationTVC = PlacesTVController()
//            passableLatitude = String(Int(rootPresentLocation.coordinate.latitude))
//            passableLongitude = String(Int(rootPresentLocation.coordinate.longitude))
            //performSegue(withIdentifier: "playerSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        if section == 1{
            return 1
        }
        if section == 2{
            return 1
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Journey Details"
        }
        if section == 1{
        return "Destination"
        }
        if section == 2{
        return "Present location"
        }
       
        return ""
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("Getting cell for Section: \(indexPath.section) Row: \(indexPath.row)")
        var cell:UITableViewCell!
        
        // Return cell for remaining journey info
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTimeCell", for: indexPath) as! DistanceTimeCell
            //cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTimeCell", for: indexPath) as! DistanceTimeCell
            
//            var destinationLocation:CLLocation?
//            if let inLat = incomingDestinationLatitude{
//                if let inLong = incomingDestinationLongitude{
//                    destinationLocation = CLLocation(latitude: Double(inLat), longitude:Double(inLong))
//                    
//                }
//            }
//            else{
//                destinationLocation = locationManager.location
//            }
//
//            rootDestinationLocation = destinationLocation
//            
//            //let destinationLocation = CLLocation(latitude: 35, longitude: 139)
//            let presentLocation = locationManager.location!
//            print("Present location is\(presentLocation)")
//            print("Destination location is \(destinationLocation)")
//            
//            
//            let remainingDistance = Double((presentLocation.distance(from: destinationLocation!)))
            
            let remainingDistance = Double((rootPresentLocation.distance(from: rootDestinationLocation!)))
            let distanceInMiles = Int(remainingDistance * 0.000621371)
            print("Remaining Distance is \(distanceInMiles) miles")
            cell.RemainingDistance.text = "\(distanceInMiles) miles"
            
            //let speed = Double(presentLocation.speed)
            let speed = Double(rootPresentLocation.speed)
            var speedInMilesPerHour = Int(speed * 3600 * 0.000621371)
            print("Speed is \(speedInMilesPerHour) miles/hr")
            cell.CurrentSpeed.text = "\(speedInMilesPerHour) miles/hr"
            if speedInMilesPerHour == 0{
                speedInMilesPerHour = 1
            }
            let remainingTime = distanceInMiles/speedInMilesPerHour
            print("Remianing time is \(String(remainingTime))")
            cell.RemainingTime.text = String(remainingTime) + " hrs"
            
            return cell
            //cell.updateLabels()
        }
            
            //Destination weather details cell display
        else if indexPath.section == 1{
            
//            print("IncomingDestinationLatitude is \(incomingDestinationLatitude)")
//            print("IncomingDestinationLongitude is \(incomingDestinationLongitude)")
//            
//            var destinationLocation:CLLocation?
//            if let inLat = incomingDestinationLatitude{
//                if let inLong = incomingDestinationLongitude{
//                    destinationLocation = CLLocation(latitude: Double(inLat), longitude:Double(inLong))
//                }
//            }
//            else{
//                destinationLocation = locationManager.location
//            }
            
            //let destinationLocation = CLLocation(latitude: Double(incomingDestinationLatitude!), longitude:Double(incomingDestinationLongitude!))
            //rootDestinationLocation = destinationLocation
            //let destinationLocationCoordinates = destinationLocation?.coordinate
            let destinationLocationCoordinates = rootDestinationLocation?.coordinate
            cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell
            print("Fetching cell data for Destination location = \(destinationLocationCoordinates?.latitude) \(destinationLocationCoordinates?.longitude)")
            
            func updateLabels(city cityName:String, temperature temp:String, weatherType wType:String)->Void{
                //Updating labels in the cell to the updated weather info
                if let weatherTypeLabel = cell.viewWithTag(100) as? UILabel{
                    print("Weather type is \(wType)")
                    weatherTypeLabel.text = wType
                }
                if let temperatureLabel = cell.viewWithTag(101) as? UILabel{
                    temperatureLabel.text = temp
                }
                if let cityNameLabel = cell.viewWithTag(102) as? UILabel{
                    cityNameLabel.text = cityName
                }
                
            }

            _ = destinationWeatherGetter.getWeatherForCoordinates(latitude: String(Int((destinationLocationCoordinates?.latitude)!)), longitude: String(Int((destinationLocationCoordinates?.longitude)!)), completionHandler: updateLabels)
            
            return cell
            
        }
            
            
            //Current location weather details display
        else if indexPath.section == 2{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell
            
            // Fetching present location
            //let presentLocationCoordinates = locationManager.location?.coordinate
            let presentLocationCoordinates = rootPresentLocation?.coordinate
            print("Fetching cell data for Present location = \(presentLocationCoordinates?.latitude) \(presentLocationCoordinates?.longitude)")
            
            func updateLabels(city cityName:String, temperature temp:String, weatherType wType:String)->Void{
                //Updating labels in the cell to the updated weather info
                if let weatherTypeLabel = cell.viewWithTag(100) as? UILabel{
                    print("Setting Weather type as \(wType)")
                    weatherTypeLabel.text = wType
                }
                if let temperatureLabel = cell.viewWithTag(101) as? UILabel{
                    print("Setting temperature label as \(temp)")
                    temperatureLabel.text = temp
                }
                if let cityNameLabel = cell.viewWithTag(102) as? UILabel{
                    print("Setting City Name as \(cityName)")
                    cityNameLabel.text = cityName
                }
                
            }
            
            //_ = currentLocationWeatherGetter.getWeatherForCoordinates(latitude: "37", longitude: "122", completionHandler: updateLabels)
            
            _ = currentLocationWeatherGetter.getWeatherForCoordinates(latitude: String(describing: Int((presentLocationCoordinates?.latitude)!)), longitude: String(describing: Int((presentLocationCoordinates?.longitude)!)), completionHandler: updateLabels)
            

//            _ = currentLocationWeatherGetter.getWeatherForCoordinates(latitude: String(describing: presentLocation?.latitude), longitude: String(describing: presentLocation?.longitude))
//           
//            //Updating labels in the cell to the updated weather info
//            if let weatherTypeLabel = cell.viewWithTag(100) as? UILabel{
//                print("Weather type is \(currentLocationWeatherGetter.weatherType)")
//                weatherTypeLabel.text = currentLocationWeatherGetter.weatherType
//            }
//            if let temperatureLabel = cell.viewWithTag(101) as? UILabel{
//                temperatureLabel.text = currentLocationWeatherGetter.temperature
//            }
//            if let cityNameLabel = cell.viewWithTag(102) as? UILabel{
//                cityNameLabel.text = currentLocationWeatherGetter.city
//                
//            }
            //cell.backgroundView = [[UIImageView alloc]] initWithImage:[UIImage imageNamed:@".png"]]
            
            return cell

        }
        
    
        return cell
        
    }
    
    
}


extension HomeTableViewController:CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.rootPresentLocation = manager.location
            print("Updated present location = \(self.rootPresentLocation.coordinate.latitude) \(self.rootPresentLocation.coordinate.longitude)")
            let indexPath = IndexPath(row: 0, section:2)
            var indexPathArray = [indexPath]
            indexPathArray.append(IndexPath(row:0, section:0))
            self.tableView.reloadRows(at: indexPathArray , with: .automatic)
        }
}
