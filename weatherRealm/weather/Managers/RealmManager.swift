//
//  RealmManager.swift
//  weather
//
//  Created by mac on 2.06.22.
//

import RealmSwift
import Darwin

class RealmManager {
    enum RealmCodesError: Int {
        case removed = 1
        case migration = 10
    }
    
    static let shared = RealmManager()
    
    private let dataBaseName = "default.realm"
    private var version: UInt64 {
        set {
            UserDefaults.standard.set(newValue, forKey: "versionRealm")
        }
        
        get {
            return UInt64((UserDefaults.standard.object(forKey: "versionRealm") as? Int) ?? 1)
        }
    }
    
    private var dataBasePath: URL {
        return FileServiceManager.shared.documentDirectory.appendingPathComponent(self.dataBaseName)
    }
    
    private lazy var realm: Realm = {
        do {
            return try initRealm()
        } catch(let e) {
            guard let error = RealmCodesError(rawValue: (e as NSError).code) else { return try! initRealm() }
            
            switch error {
            case .migration: version += 1
            case .removed:
                version = 1
                try! FileManager.default.removeItem(at: dataBasePath)
            }
            
            return try! initRealm()
        }
    }()
    
    func initRealm() throws -> Realm {
        let config = Realm.Configuration(schemaVersion: version)
        Realm.Configuration.defaultConfiguration = config
        let _realm = try Realm()
        return _realm
    }
    
//    https://studio-releases.realm.io/latest/download/mac-dmg
    
    func addWeather(weather: Welcome, source: SourceType) {
        let weather = WeatherRealmDB(weather: weather, source: source)
//        print(realm.configuration.fileURL)
            do {
                
                try self.realm.write({
                    self.realm.add(weather, update: .modified)
                    print("added")
                })
            } catch(let e) {
                print(e.localizedDescription)
            }
        }
    
    func getWeatherRealm(source: String) -> [Welcome] {
        return realm.objects(WeatherRealmDB.self).filter("source == %@", source).map { $0.mappedWeather() }
    }
    
    func deleteRealmByDate(date: Int64) {
        do {
            let removeObject = realm.objects(WeatherRealmDB.self).filter("date == %ld", date)
                try self.realm.write({
                    self.realm.delete(removeObject)
                })
        } catch(let e) {
            print(e.localizedDescription)
        }
    }
    
    func deleteRealmAll() {
        do {
                try self.realm.write({
                    self.realm.deleteAll()
                })
        } catch(let e) {
            print(e.localizedDescription)
        }
    }

    func getObserverWeather(with date: Int64) -> Results<WeatherRealmDB> {
        return realm.objects(WeatherRealmDB.self).filter("date == %ld", date)
     
    }
}
