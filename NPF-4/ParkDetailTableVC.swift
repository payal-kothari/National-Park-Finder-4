//
//  ParkDetailTableVC.swift
//  NPF-4
//
//  Created by Payal Kothari on 4/23/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import CoreLocation


class ParkDetailTableVC: UITableViewController {
    
    var selectedPark = Park()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = selectedPark.getParkName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            if let url = URL(string: selectedPark.getLink()){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else if indexPath.section == 4 {       // showMap
            self.tabBarController?.selectedIndex = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showMapFlag = 1
            appDelegate.selectedParkToShowONMap = selectedPark.getLocation()
        }else if indexPath.section == 5 {
            // save in userDefaults
            var array = UserDefaults.standard.array(forKey: "favorites") as? [String]
            if array != nil {
                if !(array?.contains(selectedPark.getParkName()))! {
                    array!.append(selectedPark.getParkName())
                }
            } else {
                array = []
            }
            UserDefaults.standard.set(array, forKey:"favorites")
            let msg = "\(selectedPark.getParkName()) added to favorites"
            let alert = UIAlertController(title: "Favorites", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstCell = tableView.dequeueReusableCell(withIdentifier: "parkDetailCellFirst", for: indexPath) as! TableViewCellFirst
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                firstCell.labelCell?.text =  selectedPark.getParkName()
            }else if indexPath.row == 1 {
                firstCell.labelCell.text =  selectedPark.getParkLocation()
            }else if indexPath.row == 2 {
                firstCell.labelCell.text =  selectedPark.getArea()
            }else if indexPath.row == 3 {
                firstCell.labelCell.text =   "Date formed: " + selectedPark.getDateFormed()
            }
            return firstCell
        
        }else if indexPath.section == 1{
            let secondCell = tableView.dequeueReusableCell(withIdentifier: "parkDetailCellSecond", for: indexPath) as! TableViewCellSecond
            if let url = NSURL(string: selectedPark.getImageLink()) {
                if let data =  NSData(contentsOf: url as URL) {
                    secondCell.imageViewCell.image = UIImage(data: data as Data)
                }
            }
            return secondCell
        }else if indexPath.section == 2 {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 140
            firstCell.labelCell?.translatesAutoresizingMaskIntoConstraints = false
            firstCell.labelCell?.text  = selectedPark.getParkDescription()
            return firstCell
        }else if indexPath.section == 3 {
            firstCell.labelCell?.text  = selectedPark.getLink()
            return firstCell
        }else if indexPath.section == 4 {
            firstCell.labelCell?.text  = "Show on map"
            return firstCell
        }else{
            firstCell.labelCell?.text  = "Add to Favorites"
            return firstCell
        }
        return firstCell
    }
}
