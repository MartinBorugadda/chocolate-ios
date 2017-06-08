//
//  AppDelegate.swift
//  Chocolate
//
//  Created by AT on 11/24/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        
        _ = window?.rootViewController as? HomeTableViewController
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){(accepted,error) in
            if !accepted{
                print("Notification access denied")
            }
            
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }


    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func scheduleNotification(latitude lat:Double, longitude lon:Double, radius rad:Double){
        
        let center = CLLocationCoordinate2D(latitude:lat, longitude:lon)
        let region = CLCircularRegion(center:center, radius:rad, identifier:"Syracuse")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region:region, repeats:false)
        let content = UNMutableNotificationContent()
        content.title = "Close to destination"
        content.body = "This is a location notification"
        content.sound = UNNotificationSound.default()
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            print("URL for logo is \(url)")
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }

        let request = UNNotificationRequest(identifier:"textNotification", content: content, trigger:trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request){
            (error) in
            if let error = error{
                print("Error in adding request \(error)")
            }
        }
        print("Location alarm set for \(region)")
        
    }
    
    
    func scheduleNotificationForCalendar(at date: Date){
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        //let trigger = UNLocationNotificationTrigger(region:region, repeats:false)
        let content = UNMutableNotificationContent()
        content.title = "Calendar Notification"
        content.body = "This is a calendar notification"
        content.sound = UNNotificationSound.default()
        
        
        let request = UNNotificationRequest(identifier:"calendarNotification", content: content, trigger:trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request){
            (error) in
            if let error = error{
                print("Error in adding request \(error)")
            }
        }
        print("Calendar Notification set for \(newComponents)")
        
    }
    
    
    func scheduleLocationNotificationUsingCalendarNotification(at date: Date){
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute!+2, second: components.second!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        //let trigger = UNLocationNotificationTrigger(region:region, repeats:false)
        let content = UNMutableNotificationContent()
        content.title = "Close to the region"
        content.body = "WAKE UP ! YOUR NEAR YOUR LOCATION"
        content.sound = UNNotificationSound.default()
        
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            print("URL for logo is \(url)")
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }

        let request = UNNotificationRequest(identifier:"locationCalendarNotification", content: content, trigger:trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request){
            (error) in
            if let error = error{
                print("Error in adding request \(error)")
            }
        }
        print("Location Notification set using calendar alarm for \(newComponents)")
        
    }
    



}

extension AppDelegate:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState,
                         for region: CLRegion){
        
        print("Calling")
        
        let current = NSDate()
        self.scheduleLocationNotificationUsingCalendarNotification(at: current as Date)
        
        if region is CLCircularRegion{
            if state == CLRegionState.inside{
                let current = NSDate()
                self.scheduleLocationNotificationUsingCalendarNotification(at: current as Date)
            }
        }
        
        //        if region is CLCircularRegion{
        //            if UIApplication.shared.applicationState == .active {
        //                let notification = UILocalNotification()
        //                notification.alertBody = "Passive otification"
        //                notification.soundName = "Default"
        //                UIApplication.shared.presentLocalNotificationNow(notification)
        //               //showAlert(withTitle: nil, message: "Active Notification")
        //            } else {
        //                // Otherwise present a local notification
        //                let notification = UILocalNotification()
        //                notification.alertBody = "Passive otification"
        //                notification.soundName = "Default"
        //                UIApplication.shared.presentLocalNotificationNow(notification)
        //            }
        //        }
        
        
    }
    
    
}



extension AppDelegate:UNUserNotificationCenterDelegate{
    func customCompletionHandler(_ options:UNNotificationPresentationOptions)->Void{
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
}




