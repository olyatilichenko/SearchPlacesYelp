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
    var location: String?
    var coordinate: CLLocationCoordinate2D?
    
    var places:[Place]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchBar.delegate = self
        requestManager.delegate = requestAlamofireDelegate

        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.startUpdatingLocation()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let url = URL(string: yelpManager.urlString)
        var parameters = yelpManager.parameters
        let headers = yelpManager.headers
        
        if searchBar.text?.first == "#" {
            
            var text = searchBar.text
            text?.removeFirst(1)
            parameters["term"] = text
            
            if location == nil {
                guard self.coordinate == nil else {
                    parameters["latitude"] = "\(String(describing: self.coordinate?.latitude))"
                    parameters["longitude"] = "\(String(describing: self.coordinate?.longitude))"
                    return
                }
            } else {
                parameters["location"] = location
            }
            
        } else {
            self.location = searchBar.text
            parameters["location"] = location
        }
        
        requestManager.getRequest(url: url, parameters: parameters, headers: headers, completionHandler: { place in
                self.places = place
                self.mapView.showAnnotations(self.places!, animated: true)
        } )
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        if status == .denied || status == .restricted {
            showAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation: CLLocation = locations.last {
            self.coordinate = userLocation.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        showAlert()
    }
    
    func showAlert(){
        locationManager.stopUpdatingLocation()
        let alert = UIAlertController(title: "Settings", message: "Allow location from settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)! as URL)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

