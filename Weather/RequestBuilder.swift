//
//  RequestBuilder.swift
//  Weather
//
//  Created by Prashant on 2/22/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct RequestBuilder {
    func getBaseURL() -> String? {
        return Constants.baseURL
    }
    
    func getAppid() -> String? {
        return Constants.appid
    }
    
    func getImageBaseURL() -> String? {
        return Constants.imageBaseURL
    }
    
}

