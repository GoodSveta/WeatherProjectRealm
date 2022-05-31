//
//  API.swift
//  weather
//
//  Created by mac on 25.03.22.
//

import Foundation

enum APINews: String {
    case APITokenNews = "601f0ceda1ed4fbbb12446adff6b96f1"
    case hostNews = "https://newsapi.org/"
    case news = "v2/top-headlines?country=us&apiKey="

    var url: URL? {
        return URL(string: APINews.hostNews.rawValue + self.rawValue)
    }
    
    func getNewsURL() -> URL? {
        return URL(string: APINews.hostNews.rawValue + APINews.news.rawValue + APINews.APITokenNews.rawValue)
    }
}

enum API: String {
    case APIToken = "540329254207e1b494f34d141e3bdf0d"
    case host = "https://api.openweathermap.org/"
    case hostIcon = "http://openweathermap.org/img/wn/%@@2x.png"
    case city = "data/2.5/weather?q=%@&appid=%@&units=metric"
    case map = "data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric"
    var url: URL? {
        return URL(string: API.host.rawValue + self.rawValue)
        
    }

    func getNameCityURL(by name: String) -> URL? {
        let completedString = String(format: API.city.rawValue, name, API.APIToken.rawValue)
        return URL(string: API.host.rawValue + completedString)
    }
    
    func getCoordinatesURL(by lat: Double, and lon: Double) -> URL? {
        let completedString = String(format: API.map.rawValue, lat, lon, API.APIToken.rawValue)
        return URL(string: API.host.rawValue + completedString)
    }
   
    func getIconURL(by nameIcon: String) -> URL? {
            let completedString = String(format: API.hostIcon.rawValue, nameIcon)
            return URL(string: completedString)
    
       
    }
    
}

