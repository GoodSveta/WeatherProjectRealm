//
//  NetworkServiceManager.swift
//  weather
//
//  Created by mac on 25.03.22.
//

import Foundation
import UIKit
import Alamofire

class NetworkServiceManager {
    static let shared = NetworkServiceManager()
    
    func getWeather(with city: String = "Minsk", onCompleted: @escaping (Welcome) -> (),
                    onError: ((String?) -> ())?) {
        guard let url = API.city.getNameCityURL(by: city) else { return }
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let welcome = try JSONDecoder().decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        onCompleted(welcome)
                    }
                } catch (let e) {
                    DispatchQueue.main.async {
                        onError?(e.localizedDescription)
                    }
                }
            case .failure(let error):
                onError?(error.localizedDescription)
            }
        }
    }
    
    func getWeatherCoordinate(by lat: Double?, and lon: Double?, onCompleted: @escaping (Welcome) -> (),
                              onError: ((String?) -> ())?) {
        guard let url = API.map.getCoordinatesURL(by: lat ?? 0.0, and: lon ?? 0.0) else { return }
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let welcome = try JSONDecoder().decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        onCompleted(welcome)
                    }
                } catch (let e) {
                    DispatchQueue.main.async {
                        onError?(e.localizedDescription)
                    }
                }
            case .failure(let error):
                onError?(error.localizedDescription)
            }
        }
    }
     
    func getNews(onCompleted: @escaping (WelcomeNews) -> (),
                 onError: ((String?) -> ())?) {
        guard let url = APINews.news.getNewsURL() else { return }
        
        AF.request(url, headers: (["X-Api-Key" : APINews.APITokenNews.rawValue])).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let welcomeNews = try JSONDecoder().decode(WelcomeNews.self, from: data)
                    DispatchQueue.main.async {
                        onCompleted(welcomeNews)
                    }
                } catch (let e) {
                    DispatchQueue.main.async {
                        onError?(e.localizedDescription)
                    }
                }
            case .failure(let error):
                onError?(error.localizedDescription)
            }
        }
    }
}
