//
//  RouteViewController.swift
//  Chocolate
//
//  Created by AT on 12/5/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol AddGeotificationsViewControllerDelegate {
    func addGeotificationViewController(controller: RouteViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String)
}

class RouteViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,HandleMapSearch {
    
    @IBOutlet var mapView: MKMapView!
    let manager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    
    var resultSearchController:UISearchController? = nil
    var userLocationLattitude:Double?
    var userLocationLongitude:Double?
    var destinationLocationLattitude:CLLocationDegrees?
    var destinationLocationLongitude:CLLocationDegrees?
    var geotifications: [RouteGeotify] = []
    var routeOverlay: MKPolyline?
    
    var databaseReference:FIRDatabaseReference!
    var storageReference:FIRStorageReference!
    
    
    var alarmDelegate:AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = FIRDatabase.database().reference()
        
        alarmDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        if #available(iOS 9.0, *) {
            manager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        
        manager.startUpdatingLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "routeView") as! RouteTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Destination"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
        mapView.delegate = self
        //mapView.showsUserLocation = true
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "GeotifySegue"{
    //            let destinationViewController = segue.destination as? HomeTableViewController
    //
    //            //destinationController.incomingDestinationLatitude = (Int(destinationLocationLattitude!))
    //            //destinationController.incomingDestinationLongitude = (Int(destinationLocationLongitude!))
    //
    //
    //            destinationViewController?.incomingDestinationLatitude = (Int(destinationLocationLattitude!))
    //            destinationViewController?.incomingDestinationLongitude = (Int(destinationLocationLongitude!))
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func geotify(_ sender: UIBarButtonItem) {
        
        
        let destinationLatitudeString = String(describing: destinationLocationLattitude!)
        let destinationLongitudeString = String(describing: destinationLocationLongitude!)
        self.databaseReference.child("Destination").child("Latitude").setValue(destinationLatitudeString)
        self.databaseReference.child("Destination").child("Longitude").setValue(destinationLongitudeString)
        
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(Float(destinationLocationLattitude!), forKey: "destinationLatitude")
        userDefaults.set(Float(destinationLocationLongitude!), forKey: "destinationLongitude")
        userDefaults.synchronize()
        let alarmPresentLocation = manager.location
        let alarmPresentLocationCoordinates = manager.location?.coordinate
        print("Present location is \(alarmPresentLocationCoordinates?.latitude) and \(alarmPresentLocationCoordinates?.longitude)")
        //let presentCLLocation = CLLocation(latitude:(presentLocation?.latitude)!,longitude:(presentLocation?.latitude)!)
        //let destinationCLLocation = CLLocation(latitude:37.33252881,longitude:-122.05571688)
        //let distance = destinationCLLocation.distance(from: presentCLLocation)
        //print("Distance is \(distance)")
        //delegate.scheduleNotification(latitude: 37.33252881, longitude: -122.05571688, radius: 100)
        
        let alarmDestinationCLLocation = CLLocation(latitude:37.33252881,longitude:-122.05571688)
        let alarmDistanceFromDestination = alarmPresentLocation?.distance(from: alarmDestinationCLLocation)
        
        print("Distance between current location '\(alarmPresentLocationCoordinates?.latitude), \(alarmPresentLocationCoordinates?.longitude)' and destiantion '\(alarmDestinationCLLocation.coordinate.latitude), \(alarmDestinationCLLocation.coordinate.longitude)' is \(alarmDistanceFromDestination)")
        if Int(alarmDistanceFromDestination!) <= 100000{
            alarmDelegate.scheduleLocationNotificationUsingCalendarNotification(at: NSDate() as Date)
        }
        alarmDelegate.scheduleNotification(latitude: alarmPresentLocationCoordinates!.latitude, longitude: alarmPresentLocationCoordinates!.longitude, radius: 10000)
        
        let center = CLLocationCoordinate2D(latitude:(alarmPresentLocationCoordinates?.latitude)!, longitude:(alarmPresentLocationCoordinates?.longitude)!)
        let region = CLCircularRegion(center:center, radius:10000, identifier:"Syracuse")
        manager.startMonitoring(for: region)
        manager.requestState(for: region)
        
                if(geotifications.count == 0)
                {
                    //onAdd()
                    routing()
                }
                else
                {
                    remove(geotification: geotifications[0])
                    //onAdd()
                    routing()
                }
    }
    
    func add(geotification: RouteGeotify) {
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func remove(geotification: RouteGeotify) {
        if let indexInArray = geotifications.index(of: geotification) {
            geotifications.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func addRadiusOverlay(forGeotification geotification: RouteGeotify) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    func updateGeotificationsCount() {
        //segmentControl.titleForSegment(at: 1) = "GeoAlarm (\(geotifications.count))"
        navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
    }
    func removeRadiusOverlay(forGeotification geotification: RouteGeotify) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    var isInitialized = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if !isInitialized
        {
            isInitialized = true
            let location = locations[0]
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapView.showsUserLocation = true
            let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, 1500, 1500) //(myLocation, span)
            let  adjustedRegion = mapView.regionThatFits(region)
            mapView.setRegion(adjustedRegion, animated: true)
            userLocationLattitude = myLocation.latitude
            userLocationLongitude = myLocation.longitude
            print(location.speed )
            print(userLocationLattitude!)
            print(userLocationLongitude!)
            mapView.showsUserLocation = true
        }
        else{
            isInitialized = false
            let location = locations.last
            let latitude = location?.coordinate.latitude
            let longitude = location?.coordinate.longitude
            let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
            self.mapView.showsUserLocation = true
            let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, 1500, 1500) //(myLocation, span)
            let  adjustedRegion = mapView.regionThatFits(region)
            mapView.setRegion(adjustedRegion, animated: true)
            userLocationLattitude = myLocation.latitude
            userLocationLongitude = myLocation.longitude
            print(location?.speed ?? 0.0)
            print(userLocationLattitude!)
            print(userLocationLongitude!)
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Alarm")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let identifier = "myGeotification"
        if annotation is RouteGeotify {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "favIcon")!, for: .normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        else {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "favIcon"), for: .normal)
            button.addTarget(self, action: #selector(RouteViewController.printRoute), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
        
    }
    
    var rad:Double?
    
    func printRoute()
    {
        let alert = UIAlertController(title: "Radius Desired",
                                      message: "Set the radius when you want the alarm",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.default ) { (action: UIAlertAction) in
                                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                                    self.rad = (Double)(alertTextField.text!)!
                                }
                                
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertActionStyle.cancel,
                                   handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            
            textField.placeholder = "Enter Radius here"
            
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        //onAdd()
    }
    var testView:MKAnnotationView?
    
    func onAdd()
    {
        
        let coordinate = CLLocationCoordinate2D(latitude: destinationLocationLattitude!, longitude: destinationLocationLongitude!)
        let radius = rad ?? 100.0
        let identifier = NSUUID().uuidString
        let note = "HI"
        addGeotificationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note)
    }
    
    func routing()
    {
        let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLocationLattitude!, longitude: userLocationLongitude!), addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLocationLattitude!, longitude: destinationLocationLongitude!), addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            if((self.routeOverlay) != nil)
            {
                self.mapView.remove(self.routeOverlay!)
            }
            self.routeOverlay = route.polyline
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func startMonitoring(geotification: RouteGeotify) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        manager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: RouteGeotify) {
        for region in manager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            manager.stopMonitoring(for: circularRegion)
        }
    }
    
    func region(withGeotification geotification: RouteGeotify) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        return region
    }
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        else{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
            return renderer
        }
        
        //return MKOverlayRenderer(overlay: overlay)
    }
    
    
    internal func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 1000, 1000) //(myLocation, span)
        let  adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        destinationLocationLattitude = annotation.coordinate.latitude
        destinationLocationLongitude = annotation.coordinate.longitude
        print(destinationLocationLattitude!)
        print(destinationLocationLongitude!)
        
    }
    
}

extension RouteViewController: AddGeotificationsViewControllerDelegate {
    
    func addGeotificationViewController(controller: RouteViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String) {
        controller.dismiss(animated: true, completion: nil)
        let clampedRadius = min(radius, manager.maximumRegionMonitoringDistance)
        let geotification = RouteGeotify(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note)
        add(geotification: geotification)
        startMonitoring(geotification: geotification)
    }
    
}
