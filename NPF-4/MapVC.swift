//
//  MapVC.swift
//  NPF-4
//
//  Created by Payal Kothari on 4/20/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    var coords: CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var allParks = Parks()
    var parks : [Park] { //front end for LandmarkList model object
        get {
            return self.allParks.parkList
        }
        set(val) {
            self.allParks.parkList = val
        }
    }

    
    @IBAction func segmentedView(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
    }
    @IBAction func zoomOut(_ sender: UIBarButtonItem) {
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    @IBAction func zoomIn(_ sender: UIBarButtonItem) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // best accuracy
        locationManager.startUpdatingLocation()

        let userlocation = locationManager.location
        
        let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance((userlocation?.coordinate)!, 20000, 20000)
        self.mapView?.setRegion(mkCoordinateRegion, animated: true)
    }
    func showSelectedPark(parkLocation : CLLocation) {
        
        let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance(parkLocation.coordinate, 5000, 5000)
        self.mapView?.setRegion(mkCoordinateRegion, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var array = UserDefaults.standard.array(forKey: "favorites") as? [String]
        if array == nil {
            array = []
        }
        UserDefaults.standard.set(array, forKey:"favorites")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.showMapFlag == 1 {
            let mkCoordinateRegion = MKCoordinateRegionMakeWithDistance((appDelegate.selectedParkToShowONMap?.coordinate)!, 5000, 5000)
            self.mapView?.setRegion(mkCoordinateRegion, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled(){
            if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){ //request to access location when using the app
                locationManager.requestAlwaysAuthorization()        // request to access location also in background
            }
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // best accuracy
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        for park: MKAnnotation in parks{
            mapView.addAnnotation(park)
        }
       
        mapView.delegate = self
    }
    
    func mapView(_ mv: MKMapView, viewFor  annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        let identifier = "Pin"
        
        if annotation is MKUserLocation {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        if annotation !== mv.userLocation   {
            //look for an existing view to reuse
            if let dequeuedView = mv.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = MKPinAnnotationView.purplePinColor()
                view.animatesDrop = true
                view.canShowCallout = true
               
                let leftButton = UIButton(type: .infoLight)
                let rightButton = UIButton(type: .detailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
            }
            return view
        }
        
        return nil
    }
    
    
    func mapView(_ mv: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let parkAnnotation = view.annotation as! Park
        switch control.tag {
        case 0: //left button
            if let url = URL(string: parkAnnotation.getLink()){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 1: //right button
            let selectedPark = view.annotation
            let currentLocationMapItem = MKMapItem.forCurrentLocation()
            let selectedPlacemark = MKPlacemark(coordinate: (selectedPark?.coordinate)!, addressDictionary: nil)
            let selectedParkMapItem = MKMapItem(placemark: selectedPlacemark)
            let mapItems = [selectedParkMapItem, currentLocationMapItem]
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: mapItems, launchOptions:launchOptions)
        default:
            break
        }
    }


    
    
}
