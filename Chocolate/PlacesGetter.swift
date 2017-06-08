//
//  YelpGetter.swift
//  YelpApiProject
//
//  Created by AT on 12/2/16.
//  Copyright © 2016 Martin. All rights reserved.
//

import Foundation

class PlacesGetter{
    
    
    
    let PLACES_REQUEST_BASE_URI = "https://map.googleapis.com/api/place/nearbysearch/json?"
    let PLACES_API_KEY = "AIzaSyBzaezR8gwTBBiI2grixWyoueVD48BtZjg"
    
    
    func getPlaces(latitude lt:String, longitude lg:String, completionListener cl:@escaping ([PlaceInformation])->Void){
        
        let session = URLSession.shared
        let placesURL = URL(string:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lt),\(lg)&radius=5000&key=AIzaSyBzaezR8gwTBBiI2grixWyoueVD48BtZjg")!
        let dataTask = session.dataTask(with: placesURL) { (data, url, error) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                //print("Data:\n\(data!)")
                //let dataString = String(data: data!, encoding: String.Encoding.utf8)
                //print("Human-readable data:\n\(dataString!)")
                var places = [PlaceInformation]()
                do{
                    
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                    
                    guard let results = json?["results"] as? [AnyObject] else{
                        print("Error in fetching results")
                        return}
                    
                    for result in results{
                        let placeInfo = PlaceInformation()
                        guard let singleResult = result as? [String:AnyObject],
                            let nameOfPlace = singleResult["name"] as? String else{
                                print("Error in fetching name")
                                return}
                        placeInfo.name = nameOfPlace
                        //print("Name of place is \(nameOfPlace)")
                        
                        guard let icon = singleResult["icon"] as? String else{
                            print("Error in fetching icon")
                            return
                        }
                        placeInfo.iconURL = icon
                        //print("IconURL is \(icon)")
                        
                        guard let id = singleResult["place_id"] as? String else{
                            print("Error in fetching place_id")
                            return
                        }
                        placeInfo.placeID = id
                        //print("PlaceID is \(id)")
                        
                        guard let geometry = singleResult["geometry"] as? [String:AnyObject],
                            let location = geometry["location"] as? [String:Double],
                            let latitude = location["lat"] else{
                                print("Error in fetching latitude")
                                return
                        }
                        placeInfo.latitude = String(latitude)
                        //print("Latitude is \(latitude)")
                        
                        guard let longitude = location["lng"] else{
                            print("Error in fetching longitude")
                            return
                        }
                        placeInfo.longitude = String(longitude)
                        //print("Longitude is \(longitude)")
                        
                        guard let photos = singleResult["photos"] as? [AnyObject],
                            let firstPhoto = photos[0] as? [String: AnyObject],
                            let reference = firstPhoto["photo_reference"] as? String else{
                                print("Error in fetching photoReference")
                                break
                        }
                        placeInfo.imageref = reference
                        //print("Photo reference is \(placeInfo.imageref)")
                        
                        places.append(placeInfo)
                        
                        print("Appending placeName as \(placeInfo.name)")
                        
                    }
                    
                }
                catch{
                    print(error)
                }
                cl(places)
            }
        }
        dataTask.resume()
        return
    }
    
}
