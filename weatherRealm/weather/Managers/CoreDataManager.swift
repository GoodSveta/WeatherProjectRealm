//
//  CoreDataManager.swift
//  weather
//
//  Created by mac on 16.04.22.
//


import CoreData

enum SourceType: String {
    case wearherCity
    case weatherMap
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WeatherDataBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func addWeather(by weather: Welcome, source: SourceType) {
        let weatherDB = WeatherDB(context: context)
        weatherDB.setValues(by: weather, source: source)
        
        self.context.insert(weatherDB)
        saveContext()
    }
    
    func getWeatherFromDB(source: String) -> [Welcome] {
        let request = WeatherDB.fetchRequest(source: source)
        guard let weatherDB = try? self.context.fetch(request) else { return [] }
        return weatherDB.map { $0.getMappedWelcome() }
        
    }
    
    func cleareDBbyDate(date: Int64) {
        let weatherDelete = WeatherDB.fetchRequestDelete(date: date)
        guard let weatherDeleteDB = try? self.context.fetch(weatherDelete).first else { return }
        context.delete(weatherDeleteDB)
        saveContext()
        
    }
    
    func cleareDataBase() {
        let weather = WeatherDB.fetchRequest()
        print()
        do {
            let weatherDB = try self.context.fetch(weather)
            
            weatherDB.forEach{
                self.context.delete($0)
            }
        } catch (let e) {
            print(e.localizedDescription)
        }
        print()
    }
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}







