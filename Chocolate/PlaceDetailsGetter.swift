//
//  PlaceDetailsGetter.swift
//  PlacesTester
//
//  Created by AT on 12/4/16.
//  Copyright © 2016 Martin. All rights reserved.
//

import Foundation

class PlaceDetailsGetter{
    
    var PLACE_DETAILS_BASE_URL = "https://maps.googleapis.com/maps/api/place/details/json?"
    var APIKEY = "AIzaSyBzaezR8gwTBBiI2grixWyoueVD48BtZjg"
    
    func getPlaceDetails(placeID plcID:String, completionHandler cl:@escaping (PlaceAdvancedInformation)->Void){
        
        let placeAdvancedInformation = PlaceAdvancedInformation()
        let session = URLSession.shared
        let placeDetailsRequestURL = URL(string:PLACE_DETAILS_BASE_URL+"&key="+APIKEY+"&placeid="+plcID)
        print("API is \(placeDetailsRequestURL?.absoluteString)")
        let dataTask = session.dataTask(with: placeDetailsRequestURL!){(data, response, error) in
            if let error = error{
                print(error)
            }
            else{
                
                print("Data is \(data)")
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                print("Human-readable data:\n\(dataString!)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                    
                    guard let result = json?["result"] as? [String:AnyObject],
                        let address = result["formatted_address"] as? String else{
                            print("Error in fetching formatted Address")
                            return
                    }
                    placeAdvancedInformation.formattedAddress = address
                    print("The formated address is \(address)")
                    cl(placeAdvancedInformation)
                    
                    
                }
                catch{
                    print(error)
                }
            }
            
        }
        dataTask.resume()
    }
    
}
