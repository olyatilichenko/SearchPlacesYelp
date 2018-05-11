//
//  ViewController.swift
//  SearchPlacesYelp
//
//  Created by Olga on 5/3/18.
//  Copyright © 2018 Olga. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    let requestManager = RequestManager()
    let requestAlamofireDelegate = RequestAlamofireDelegate()
    let requestURLDelagate = RequestURLSessionDelegate()
    let yelpManager = YelpManager()
    
    var places:[Place]?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchBar.delegate = self
        requestManager.delegate = requestAlamofireDelegate
    
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestLocation()
        }
    }
    
    var location: String?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let url = URL(string: yelpManager.urlString)
        var parameters = yelpManager.parameters
        let headers = yelpManager.headers
        
        if (searchBar.text?.first != "#") {
            
            location = searchBar.text
            parameters["location"] = location
        }
        
        if (searchBar.text?.first == "#") {
            
            var text = searchBar.text
            text?.removeFirst(1)
            parameters["term"] = text
            
            if location == nil {
                
                parameters["latitude"] = "\(String(describing: locationManager.location!.coordinate.latitude))"
                parameters["longitude"] = "\(String(describing: locationManager.location!.coordinate.longitude))"
                
            }
            else {
                parameters["location"] = location
            }
        }
        
        requestManager.getRequest(url: url, parameters: parameters, headers: headers, completionHandler: { place in
            self.places = place
            self.mapView.showAnnotations(self.places!, animated: true)
        } )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: (error)")
    }
}

