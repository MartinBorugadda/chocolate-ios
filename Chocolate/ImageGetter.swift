//
//  ImageGetter.swift
//  PlacesTester
//
//  Created by AT on 12/4/16.
//  Copyright © 2016 Martin. All rights reserved.
//

import Foundation
import UIKit

class ImageGetter{
    
    var sample = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyBzaezR8gwTBBiI2grixWyoueVD48BtZjg&maxwidth=500&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU"
    
    var IMAGES_BASE_URL = "https://maps.googleapis.com/maps/api/place/photo?"
    var APIKEY = "AIzaSyBzaezR8gwTBBiI2grixWyoueVD48BtZjg"
    func getImage(reference ref:String, height maxHeight:String, width maxWidth:String, completionHandler cl:@escaping (Data)->Void){
        let session = URLSession.shared
        let imageURL = URL(string:IMAGES_BASE_URL+"maxheight="+maxWidth+"&photoreference="+ref+"&key="+APIKEY)
        
        let dataTask = session.dataTask(with: imageURL!){
            (data, response, error) in
            if let error = error{
                print(error)
            }
            else{
                cl(data!)
            }
            
        }
        dataTask.resume()
        
        
    }
    
    
}
