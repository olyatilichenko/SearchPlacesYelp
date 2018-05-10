//
//  Place.swift
//  SearchPlacesYelp
//
//  Created by Olga on 5/4/18.
//  Copyright © 2018 Olga. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init?(json: [String: Any]) {
        guard
            let title = json["name"] as? String,
            let location = json["location"] as? [String: Any],
            let subtitle = location["address1"] as? String,
            let coordinates = json["coordinates"] as? [String: Any],
            let latitude = coordinates["latitude"] as? Double,
            let longitude = coordinates["longitude"] as? Double
            else {
                return nil
        }
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func getArray(from array: Array<[String: Any]>) -> [Place]? {

        var places: [Place] = []
        
        for jsonObject in array {
            if let place = Place(json: jsonObject) {
                places.append(place)
            }
        }
        return places
    }
}

