//
//  Request.swift
//  TestAlamofire
//
//  Created by Olya Tilichenko on 20.04.2018.
//  Copyright © 2018 Olya Tilichenko. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    
    var delegate: RequestManagerDelegate?
    
    func getRequest(url: URL?, parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping ([Place]?)-> Void) -> () {
        
        if let urlValue = url, let parametersValue = parameters, let headersValue  = headers {
            delegate?.getRequest(url: urlValue, parameters: parametersValue, headers: headersValue, completionHandler: { place in completionHandler(place) })
        }
    }
    
    func postRequest(url: URL?, parameters: Parameters?, headers: HTTPHeaders?) -> () {
        
        if let urlValue = url, let parametersValue = parameters, let headersValue  = headers {
            delegate?.postRequest(url: urlValue, parameters: parametersValue, headers: headersValue)
        }
    }
}

protocol RequestManagerDelegate {
    
    func getRequest(url: URL, parameters: Parameters, headers: HTTPHeaders, completionHandler: @escaping ([Place]?)-> Void)
    func postRequest(url: URL, parameters: Parameters, headers: HTTPHeaders)
}

class RequestAlamofireDelegate: RequestManagerDelegate {

    func getRequest(url: URL, parameters: Parameters, headers: HTTPHeaders, completionHandler: @escaping ([Place]?)-> Void) {
        
        request(url, parameters: parameters, headers: headers).responseJSON { responsejs in
            
            var places: [Place]?
            switch responsejs.result {
            case .success(let value):
                if let businesses = value as? [String: Any] {
                    places = Place.getPlaces(from: businesses)
                    completionHandler(places)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
    
    func postRequest(url: URL, parameters: Parameters, headers: HTTPHeaders) {
        
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responsejs in
            switch responsejs.result{
            case .success(let value):
                print(value)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

class RequestURLSessionDelegate: RequestManagerDelegate {
    
    func getRequest(url: URL, parameters: Parameters, headers: HTTPHeaders, completionHandler: @escaping ([Place]?)-> Void) {
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            var places: [Place]?
            
            guard error == nil else {
                print(error!.localizedDescription as Any)
                return
            }
            
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    places = Place.getPlaces(from: json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            completionHandler(places)
        }
        task.resume()
    }
    
    func postRequest(url: URL, parameters: Parameters, headers: HTTPHeaders) {
        
        var request = URLRequest(url: url)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            print(error.localizedDescription)
        
        }
        request.allHTTPHeaderFields = headers
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
