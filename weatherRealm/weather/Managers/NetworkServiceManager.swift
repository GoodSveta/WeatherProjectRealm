//
//  NetworkServiceManager.swift
//  weather
//
//  Created by mac on 25.03.22.
//

import Foundation
import UIKit

class NetworkServiceManager {
    static let shared = NetworkServiceManager()
    
    func getWeather(with city: String = "Minsk", onCompleted: @escaping (Welcome) -> (),
                    onError: ((String?) -> ())?) {
        guard let url = API.city.getNameCityURL(by: city) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
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
        }.resume()
    }
    
    func getWeatherCoordinate(by lat: Double?, and lon: Double?, onCompleted: @escaping (Welcome) -> (),
                              onError: ((String?) -> ())?) {
        guard let url = API.map.getCoordinatesURL(by: lat ?? 0.0, and: lon ?? 0.0) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
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
        }.resume()
    }
    
    func getNews(onCompleted: @escaping (WelcomeNews) -> (),
                 onError: ((String?) -> ())?) {
        guard let url = APINews.news.getNewsURL() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(APINews.APITokenNews.rawValue, forHTTPHeaderField: "X-Api-Key")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
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
        }.resume()
    }
}
