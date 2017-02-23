//
//  WeatherCell.swift
//  Weather
//
//  Created by Prashant on 2/22/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    var data: WeatherList = WeatherList.init(data: nil) {
        didSet{
            if let description = data.weather?.description, let txt = data.dt_txt {
                weatherDescription.text = description
                weatherLabel.text = txt //TODO: Can use dateFormatter here and convert the time in proper format before displaying on the UI
            }
            
            if let weather = data.weather {
                if let icon = weather.icon, let imageBaseURL = RequestBuilder().getImageBaseURL() {
                    guard let imageUrl = URL.init(string: imageBaseURL + icon + ".png") else {
                        return
                    }
                    self.icon.downloadedFrom(url: imageUrl)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        weatherLabel.text = nil
        icon.image = nil
    }
    
}
