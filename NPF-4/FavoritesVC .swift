//
//  FavoritesVC .swift
//  NPF-4
//
//  Created by Payal Kothari on 4/23/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit

class FavoritesVC: UITableViewController {
    
    var favoriteParks : [String] = []
    var allParksTable = Parks()
    var parksTable : [Park] { //front end for LandmarkList model object
        get {
            return self.allParksTable.parkList
        }
        set(val) {
            self.allParksTable.parkList = val
        }
    }
    
    override func viewDidLoad() {
        self.isEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isEditing = false
        favoriteParks = UserDefaults.standard.array(forKey: "favorites") as! [String]
        tableView.reloadData()
    }
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        self.isEditing = false
    }
    @IBAction func editTable(_ sender: UIBarButtonItem) {
        self.isEditing = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationViewController = segue.destination as! ParkDetailTableVC
            for p in parksTable {
                if p.getParkName() == favoriteParks[indexPath.row] {
                    destinationViewController.selectedPark = p
                    let backButton = UIBarButtonItem()
                    backButton.title = "Parks"
                    self.navigationItem.backBarButtonItem = backButton
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = favoriteParks[sourceIndexPath.row]
        favoriteParks.remove(at: sourceIndexPath.row)
        favoriteParks.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteParks.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesTableCell", for: indexPath)
        cell.textLabel?.text = favoriteParks[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            favoriteParks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        var array = UserDefaults.standard.array(forKey: "favorites") as? [String]
        if array != nil {
            if (array?.contains((array?[indexPath.row])!))! {
                array!.remove(at: indexPath.row)
            }
        }
        UserDefaults.standard.set(array, forKey:"favorites")
    }
}
