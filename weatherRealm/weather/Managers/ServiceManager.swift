//
//  ServiceManager.swift
//  weather
//
//  Created by mac on 29.04.22.
//

import UIKit

class ServiceManager {
    static let shared = ServiceManager()
    
    func unixTimeConvertion(unixTime: Double) -> String {
        let time = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.system.identifier) as Locale?
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateAsString = dateFormatter.string(from: time as Date)
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date24 = dateFormatter.string(from: date!)
        return  date24
    }
}
