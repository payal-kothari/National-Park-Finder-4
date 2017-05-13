//
//  AppDelegate.swift
//  NPF-4
//
//  Created by Payal Kothari on 4/20/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?
    var parks: [Park] = []
    var showMapFlag = 0
    var selectedParkToShowONMap: CLLocation? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        
        loadData()
        
        tabBarController = window?.rootViewController as? UITabBarController
        let mapVC = tabBarController?.viewControllers![0] as! MapVC
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let navVC2 = tabBarController?.viewControllers![2] as! UINavigationController
        let favVC = navVC2.viewControllers[0] as! FavoritesVC
        let parkVC = navVC.viewControllers[0] as! ParkTableVC
        let parksList = Parks()
        parksList.parkList = parks
        parkVC.allParksTable = parksList
        mapVC.allParks = parksList
        favVC.allParksTable = parksList
        
        return true
    }

    func loadData() {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist") {
            let tempDict = NSDictionary(contentsOfFile: path)
            let tempArray = (tempDict!.value(forKey: "parks") as! NSArray) as Array
            
            for dict in tempArray {
                let parkName = dict["parkName"]! as! String
                let parkLocation = dict["parkLocation"]! as! String
                let latitude = (dict["latitude"]! as! NSString).doubleValue
                let longitude = (dict["longitude"]! as! NSString).doubleValue
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let area = dict["area"]! as! String
                let dateFormed = dict["dateFormed"]! as! String
                let description = dict["description"]! as! String
                let imageLink = dict["imageLink"]! as! String
                let imageName = dict["imageName"]! as! String
                let imageSize = dict["imageSize"]! as! String
                let imageType = dict["imageType"]! as! String
                let link = dict["link"]! as! String
                let distanceN = 0.0
                
                let p = Park(parkName: parkName, parkLocation: parkLocation, dateFormed: dateFormed, area: area, link: link, location: location, imageLink: imageLink, parkDescription: description, imageName: imageName, imageSize: imageSize, imageType: imageType, distanceH: Float(distanceN))
                
                parks.append(p)
            }
        }
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


}

