//
//  DataManager.swift
//  Weather
//
//  Created by Prashant on 2/22/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct DataManager {
    
    func getDataFor(_ city: String , completion: @escaping CompletionHandler) -> Void{
        RequestManager().getDataFor(city) { (success, fetchedData, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
                return
            }
            if let data = fetchedData as? NSData, let weatherData = DataManager.parse(data) {
                DispatchQueue.main.async {
                    completion(true, weatherData, nil)
                }
            } else {
                // Throw error
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
            }
        }
    }
    
    // parse fetched data
    static func parse(_ data: NSData) -> WeatherData? {
        do {
            let res = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            if let dict: NSDictionary = res as? NSDictionary {
                let weatherData: WeatherData = WeatherData.init(data: dict)
                return weatherData
            }
        } catch {
            print("Failed to parse data")
        }
        return nil
    }
}

struct WeatherData {
    var message: Double?
    var cod: String?
    var cnt: Int?
    var list: [WeatherList]?
    var city: City?
    init(data: NSDictionary) {
        self.message = data["message"] as? Double
        self.cod = data["cod"] as? String
        self.cnt = data["cnt"] as? Int
        self.city = City.init(data: data["city"] as? NSDictionary)
        
        // Loop through array and parse data
        if let list: NSArray = data["list"] as? NSArray {
            var array: [WeatherList] = [WeatherList]()
            
            for object in list {
                array.append(WeatherList.init(data: object as? NSDictionary))
            }
            self.list = array
        }
    }
}

struct City {
    var coord: Coordinate?
    var country: String?
    var id: Int?
    var name: String?
    init(data: NSDictionary?) {
        self.coord = Coordinate.init(data: data?["coord"] as? NSDictionary)
        self.country = data?["country"] as? String
        self.id = data?["id"] as? Int
        self.name = data?["name"] as? String
    }
}


struct Coordinate {
    var lat: String?
    var lon: String?
    
    init(data: NSDictionary?) {
        self.lat = data?["lat"] as? String
        self.lon = data?["lon"] as? String
    }
}


struct WeatherList {
    var clouds: Cloud?
    var wind: Wind?
    var dt: Int?
    var dt_txt: String?
    var main: Main?
    var weather: Weather?
    var sys: Sys?
    var rain: Rain?
    var snow: Snow?
    init(data: NSDictionary?) {
        self.clouds = Cloud.init(data: data?["clouds"] as? NSDictionary)
        self.wind = Wind.init(data: data?["wind"] as? NSDictionary)
        self.dt = data?["dt"] as? Int
        self.dt_txt = data?["dt_txt"] as? String
        self.main = Main.init(data: data?["main"] as? NSDictionary)
        
        let weatherArray =  data?["weather"] as? NSArray
        self.weather = Weather.init(data: weatherArray?.firstObject as! NSDictionary?)
        
        self.sys = Sys.init(data: data?["sys"] as? NSDictionary)
        self.rain = Rain.init(data: data?["rain"] as? NSDictionary)
        self.snow = Snow.init(data: data?["snow"] as? NSDictionary)
    }
}

struct Cloud {
    var all: Int?
    
    init(data: NSDictionary?) {
        self.all = data?["all"] as? Int
    }
}


struct Wind {
    var speed: Double?
    var deg: Double?
    
    init(data: NSDictionary?) {
        self.speed = data?["speed"] as? Double
        self.deg = data?["deg"] as? Double
    }
}

struct Main {
    var humidity: Int?
    var temp_min: Double?
    var temp_kf: Double?
    var temp_max: Double?
    var temp: Double?
    var pressure: Double?
    var sea_level: Double?
    var grnd_level: Double?
    
    init(data: NSDictionary?) {
        self.humidity = data?["humidity"] as? Int
        self.temp_min = data?["temp_min"] as? Double
        self.temp_kf = data?["temp_kf"] as? Double
        self.temp_max = data?["temp_max"] as? Double
        self.temp = data?["temp"] as? Double
        self.pressure = data?["pressure"] as? Double
        self.sea_level = data?["sea_level"] as? Double
        self.grnd_level = data?["grnd_level"] as? Double
    }
}


struct Weather {
    var id: Int?
    var main: String?
    var icon: String?
    var description: String?
    
    init(data: NSDictionary?) {
        self.id = data?["id"] as? Int
        self.main = data?["main"] as? String
        self.icon = data?["icon"] as? String
        self.description = data?["description"] as? String
    }
}

struct Sys {
    var pod: String?
    
    init(data: NSDictionary?) {
        self.pod = data?["pod"] as? String
    }
}

struct Rain {
    var threeH: Double?
    
    init(data: NSDictionary?) {
        self.threeH = data?["3h"] as? Double
    }
}

struct Snow {
    var threeH: Double?
    
    init(data: NSDictionary?) {
        self.threeH = data?["3h"] as? Double
    }
}

