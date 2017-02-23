//
//  Constants.swift
//  Weather
//
//  Created by Prashant on 2/22/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ success: Bool , _ data: Any? , _ error: Error?) -> Void

struct Constants {
    static let baseURL: String = "http://samples.openweathermap.org/data/2.5/forecast?"
    static let appid: String = "b1b15e88fa797225412429c1c50c122a1"
    static let imageBaseURL: String = "http://openweathermap.org/img/w/"
}

//  Image download helper methods

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

