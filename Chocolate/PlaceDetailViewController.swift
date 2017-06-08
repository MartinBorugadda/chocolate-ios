//
//  PlaceDetailViewController.swift
//  PlacesTester
//
//  Created by AT on 12/3/16.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {
    
    var currentPlaceInfo:PlaceInformation!
    var imageGetter = ImageGetter()
    var placeDetailsGetter = PlaceDetailsGetter()
    var PlaceLatitude:String!
    var PlaceLongitude:String!
    
    @IBOutlet weak var PlaceIageView: UIImageView!
    
    @IBOutlet weak var PlaceNameLabel: UILabel!
    
    @IBOutlet weak var PlaceAddressLabel: UILabel!
    
    @IBOutlet weak var PlaceMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentPlaceInfo.name
        updateLabels()
        
        func loadImage(inData:Data){
            if let image = UIImage(data: inData){
                PlaceIageView.image = image
                
            }
        }
        
        imageGetter.getImage(reference: currentPlaceInfo.imageref, height: "500", width: "400", completionHandler: loadImage)
        func updateAdvancedDetails(placeAI:PlaceAdvancedInformation){
            PlaceAddressLabel.text = placeAI.formattedAddress
        }
        
        placeDetailsGetter.getPlaceDetails(placeID: currentPlaceInfo.placeID, completionHandler:updateAdvancedDetails)
        
        let locationCL = CLLocation(latitude:Double(PlaceLatitude)!, longitude:Double(PlaceLongitude)!)
        let location = CLLocationCoordinate2D(latitude:Double(PlaceLatitude)!, longitude:Double(PlaceLongitude)!)
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(locationCL.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        let placeMark = MKPlacemark(coordinate: location, addressDictionary:[" ":" "])
        //PlaceMapView.setCenter(locationCL, animated: true)
        PlaceMapView.setRegion(coordinateRegion, animated: true)
        PlaceMapView.addAnnotation(placeMark)
        
        // Do any additional setup after loading the view.
    }
    
    func updateLabels(){
        PlaceNameLabel.text = currentPlaceInfo.name
        //PlaceAddressLabel.text = currentPlaceInfo.latitude + currentPlaceInfo.longitude
    }
    
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
