//
//  WeatherDB+CoreDataProperties.swift
//  
//
//  Created by mac on 16.04.22.
//
//

import Foundation
import CoreData


extension WeatherDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDB> {
        return NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
    }
    
    @nonobjc public class func fetchRequest(source: String) -> NSFetchRequest<WeatherDB> {
        let request = NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
        request.predicate = NSPredicate(format: "source == %@", source)
        return request
    }
    
    @nonobjc public class func fetchRequestDelete(date: Int64) -> NSFetchRequest<WeatherDB> {
        let request = NSFetchRequest<WeatherDB>(entityName: "WeatherDB")
        request.predicate = NSPredicate(format: "date == %ld", date)
        return request
    }
    

    @NSManaged public var date: Int64
    @NSManaged public var source: String?
    @NSManaged public var country: String?
    @NSManaged public var temp: Double
    @NSManaged public var feelsLike: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var pressure: Int64
    @NSManaged public var humidity: Int64
    @NSManaged public var coordLon: Double
    @NSManaged public var coordLat: Double
    @NSManaged public var name: String?
    @NSManaged public var visibility: Int64
    @NSManaged public var cloudsAll: Int64
    @NSManaged public var icon: String?
    @NSManaged public var windSpeed: Double
    @NSManaged public var weatherDescription: String?

    
    func getMappedWelcome() -> Welcome {
        return Welcome(coord: Coord(lon: coordLon, lat: coordLat),
                       weather: [Weather.init(id: 0, main: "", weatherDescription: weatherDescription ?? "", icon: icon ?? "")],
                       base: "",
                       main: Main(temp: temp, feelsLike: feelsLike, tempMin: tempMin, tempMax: tempMax, pressure: Int(pressure), humidity: Int(humidity)),
                       visibility: Int(visibility),
                       wind: Wind(speed: windSpeed, deg: 0),
                       clouds: Clouds(all: Int(cloudsAll)),
                       dt: Int(date),
                       sys: Sys(type: 0, id: 0, country: country ?? "", sunrise: 0, sunset: 0),
                       timezone: 0,
                       id: 0,
                       name: name ?? "",
                       cod: 0)
        }
    
    func setValues(by weather: Welcome, source: SourceType) {
        self.icon = weather.weather.first?.icon ?? ""
        self.weatherDescription = weather.weather.first?.weatherDescription ?? ""
        self.date = Int64(weather.dt)
        self.country = weather.sys.country
        self.temp = weather.main.temp
        self.feelsLike = weather.main.feelsLike
        self.tempMin = weather.main.tempMin
        self.tempMax = weather.main.tempMax
        self.pressure = Int64(weather.main.pressure)
        self.humidity = Int64(weather.main.humidity)
        self.coordLon = weather.coord.lon
        self.coordLat = weather.coord.lat
        self.name = weather.name
        self.visibility = Int64(weather.visibility)
        self.cloudsAll = Int64(weather.clouds.all)
        self.windSpeed = weather.wind.speed
        self.source = source.rawValue

 
        
    }
    
}
    
        
