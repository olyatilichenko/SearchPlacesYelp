//
//  YelpManager.swift
//  SearchPlacesYelp
//
//  Created by Olga on 5/3/18.
//  Copyright © 2018 Olga. All rights reserved.
//

import Foundation
import Alamofire

class YelpManager {
    
    let urlString = "https://api.yelp.com/v3/businesses/search"
    
    var parameters: Parameters = [:]
    
    let headers: HTTPHeaders = [
        //"Content-Type" : "application/json",
        "Authorization" : "Bearer kEPM_TYrBnQPZNklCvCGUqLBmzZDjRo9EI8YK0JpctXQ3SG6LnOF2vE3gSujebmQwlwpprNNhXy5TwcSYwxOCgEXr3pynmnSGSsb5STmGz3j0bGj6XmRqA_sq__qWnYx"
    ]
}


