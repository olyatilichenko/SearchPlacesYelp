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
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        searchBar.delegate = self
        requestManager.delegate = requestAlamofireDelegate
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("text did change")
    }
    
    var location: String?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
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
        
        if let request = requestManager.getRequest(url: url, parameters: parameters, headers: headers) {
            
            places = request
            mapView.addAnnotations(places!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        //mapView.centerCoordinate = (locations.last?.coordinate)!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: (error)")
    }
}

