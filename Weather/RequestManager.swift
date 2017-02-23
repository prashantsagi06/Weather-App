//
//  RequestManager.swift
//  Weather
//
//  Created by Prashant on 2/22/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct RequestManager {
    
    func getDataFor(_ city: String, completion: @escaping CompletionHandler) -> Void {
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        guard let urlString = RequestBuilder().getBaseURL() else {
            print("URLString can't be nil")
            return
        }
        
        guard let appid = RequestBuilder().getAppid() else {
            print("appid can't be nil")
            return
        }
        
        // Remove any white space from city to make sure that URL is not broken
        let updatedCity = city.components(separatedBy: .whitespaces).joined()
        
        guard let url = URL.init(string: urlString + "q=\(updatedCity)" + "&" + "appid=\(appid)") else {
            print("URL can't be nil")
            return
        }
        
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                completion(false, nil , error)
                return
            }
            completion(true, data , nil)
        }
        task.resume()
    }
    
}


