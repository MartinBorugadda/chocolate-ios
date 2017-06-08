//
//  WeatherGetter.swift
//  Chocolate
//
//  Created by AT on 11/27/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import Foundation
import UIKit

class WeatherGetter{
    
    let WEATHER_REQUEST_BASE_URI = "http://api.openweathermap.org/data/2.5/weather"
    let WEATHER_API_KEY = "586794ef8168571fac0e040c39241fe3"
    var weatherType = ""
    var temperature = ""
    var city = ""
    
    
    
    //Get weather for a particulary city
    func getWeatherForCity(cityName:String)->String{
        city = cityName
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(WEATHER_REQUEST_BASE_URI)?APPID=\(WEATHER_API_KEY)&q=\(cityName)")!

        let dataTask = session.dataTask(with: weatherRequestURL) { (data, url, error) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
               // print("Data:\n\(data!)")
                _ = String(data: data!, encoding: String.Encoding.utf8)
                //print("Human-readable data:\n\(dataString!)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                    guard let coord = json?["coord"] as? [String:AnyObject],
                    let long = coord["lon"] as? Int else{
                        return}
                    print("Martin long is \(long)")
                    
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
        return "weather"
    }
    
    //Get weather for a location based on its coordinates
    func getWeatherForCoordinates(latitude lat:String, longitude lon:String)->(String, String, String){
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(WEATHER_REQUEST_BASE_URI)?APPID=\(WEATHER_API_KEY)&lat=\(lat)&lon=\(lon)")!
        
        let dataTask = session.dataTask(with: weatherRequestURL) { (data, url, error) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                //print("Data:\n\(data!)")
                _ = String(data: data!, encoding: String.Encoding.utf8)
                //print("Human-readable data:\n\(dataString!)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                    
                    guard let weather = json?["weather"] as? [AnyObject],
                    let wType = weather[0] as? [String:AnyObject],
                        let wthType = wType["main"] as? String else{
                            print("Error in fetching main")
                            return}
                    self.weatherType = wthType
                    print("Weather type is \(self.weatherType)")
                    
                    guard let main = json?["main"] as? [String:AnyObject],
                        let temper = main["temp"] as? Int else{
                            print("Error in fetching temp")
                            return}
                    self.temperature = String(temper)
                    print("Temperature is \(self.temperature)")
                    
                    guard let cName = json?["name"] as? String else{
                        print("Error in fetching name")
                            return}
                    self.city = cName
                    print("City is \(self.city)")
                    
                    
                    
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
        return (self.city, self.temperature, self.weatherType)
        //return ("","","")
    }
    
    
    //Get weather for a location based on its coordinates
    func getWeatherForCoordinates(latitude lat:String, longitude lon:String, completionHandler comp:@escaping (String, String, String)->Void)->(String, String, String){
        
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(WEATHER_REQUEST_BASE_URI)?APPID=\(WEATHER_API_KEY)&lat=\(lat)&lon=\(lon)")!
        
        let dataTask = session.dataTask(with: weatherRequestURL) { (data, url, error) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                print("Data:\n\(data!)")
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                print("Human-readable data:\n\(dataString!)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                    
                    guard let weather = json?["weather"] as? [AnyObject],
                        let wType = weather[0] as? [String:AnyObject],
                        let wthType = wType["main"] as? String else{
                            print("Error in fetching main")
                            return}
                    self.weatherType = wthType
                    print("Weather type is \(self.weatherType)")
                    
                    guard let main = json?["main"] as? [String:AnyObject],
                        let temper = main["temp"] as? Int else{
                            print("Error in fetching temp")
                            return}
                    self.temperature = String(temper)
                    print("Temperature is \(self.temperature)")
                    
                    guard let cName = json?["name"] as? String else{
                        print("Error in fetching name")
                        return}
                    self.city = cName
                    print("City is \(self.city)")
                    
                    comp(self.city, self.temperature, self.weatherType)
                    
                    
                    
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
        return (self.city, self.temperature, self.weatherType)
        //return ("","","")
    }


    
}
