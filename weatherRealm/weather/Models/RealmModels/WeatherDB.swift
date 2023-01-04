//
//  WeatherDB.swift
//  weather
//
//  Created by mac on 2.06.22.
//

import RealmSwift

class WeatherRealmDB: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var date: Int64
    @Persisted var source: String?
    @Persisted var country: String?
    @Persisted var temp: Double
    @Persisted var feelsLike: Double
    @Persisted var tempMin: Double
    @Persisted var tempMax: Double
    @Persisted var pressure: Int64
    @Persisted var humidity: Int64
    @Persisted var coordLon: Double
    @Persisted var coordLat: Double
    @Persisted var name: String?
    @Persisted var visibility: Int64
    @Persisted var cloudsAll: Int64
    @Persisted var icon: String?
    @Persisted var windSpeed: Double
    @Persisted var weatherDescription: String?
    
    convenience init(weather: Welcome, source: SourceType) {
        self.init()
        self.date = Int64(weather.dt)
        self.source = source.rawValue
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
        self.icon = weather.weather.first?.icon
        self.windSpeed = weather.wind.speed
        self.weatherDescription = weather.weather.first?.weatherDescription
        
        
    }
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mappedWeather() -> Welcome {
        return Welcome(coord: Coord(lon: self.coordLon, lat: self.coordLat),
                       weather: [Weather(id: 0, main: "", weatherDescription: self.weatherDescription ?? "", icon: self.icon ?? "")],
                       base: "", main: Main(temp: self.temp, feelsLike: self.feelsLike, tempMin: self.tempMin, tempMax: self.tempMax, pressure: Int(self.pressure), humidity: Int(self.humidity)),
                       visibility: Int(self.visibility),
                       wind: Wind(speed: self.windSpeed, deg: 0),
                       clouds: Clouds(all: Int(self.cloudsAll)),
                       dt: Int(self.date),
                       sys: Sys(type: 0, id: 0, country: self.country ?? "", sunrise: 0, sunset: 0),
                       timezone: 0, id: 0, name: self.name ?? "", cod: 0)
    }
}
