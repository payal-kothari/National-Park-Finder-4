//
//  ParkTableVC.swift
//  NPF-4
//
//  Created by Payal Kothari on 4/22/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import CoreLocation

class ParkTableVC: UITableViewController, CLLocationManagerDelegate {

    var allParksTable = Parks()
    var locationManager = CLLocationManager()
    var parksTable : [Park] { //front end for LandmarkList model object
        get {
            return self.allParksTable.parkList
        }
        set(val) {
            self.allParksTable.parkList = val
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationViewController = segue.destination as! ParkDetailTableVC
            destinationViewController.selectedPark = parksTable[indexPath.row]
            let backButton = UIBarButtonItem()
            backButton.title = "Parks"
            self.navigationItem.backBarButtonItem = backButton
        }
    }

    @IBAction func segmentedForSorting(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
                    case 0:
                        parksTable.sort(by: {$0.getParkName() < $1.getParkName()})  // sorting A-Z
                        tableView.reloadData()
                    case 1:
                        parksTable.sort(by: {$0.getParkName() > $1.getParkName()})  // sorting Z-A
                        tableView.reloadData()
            
                    case 2:
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // best accuracy
                        locationManager.startUpdatingLocation()
                        let userLocation = locationManager.location

                        for p in parksTable {
                            let pLocation = p.getLocation()
                            let dist = pLocation.distance(from: userLocation!)
                            let miles = dist * 0.000621371192
                            p.set(dist: Float(miles))
                        }
                        parksTable.sort(by: {$0.getDistance() < $1.getDistance()})
                        tableView.reloadData()
                    default:
                        parksTable.sort(by: {$0.getParkName() < $1.getParkName()})  // sorting A-Z
                        tableView.reloadData()
                    }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parksTable.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath)

        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // best accuracy
        locationManager.startUpdatingLocation()
        let userLocation = locationManager.location
        let parkLocation = parksTable[indexPath.row].getLocation()
        let distance = parkLocation.distance(from: userLocation!)
        let distanceMiles = distance *  0.000621371192

        cell.textLabel?.text = parksTable[indexPath.row].getParkName()  // pass by value
        cell.detailTextLabel?.text = String(format: "Distance: %.2f miles", distanceMiles)
        return cell
    }
    

}
