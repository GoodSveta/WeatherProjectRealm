//
//  RCManager.swift
//  weather
//
//  Created by mac on 3.05.22.
//
import UIKit
import FirebaseCore
import FirebaseRemoteConfig

enum ValueKey: String {
    case mapType
    case showNews
}

class RCManager {
    static let shared = RCManager()
    init() {
        loadDefaultValues() 
        activateDebugMode()
    }
    private func activateDebugMode() {
        let debugSettings = RemoteConfigSettings()
        RemoteConfig.remoteConfig().configSettings = debugSettings
    }
    private func loadDefaultValues() {
        let defaultValues: [String: Any?] = [
            ValueKey.mapType.rawValue:"apple",
            ValueKey.showNews.rawValue: true
        ] //если нет интернета, то
        RemoteConfig.remoteConfig().setDefaults(defaultValues as? [String: NSObject])
    }
    func connect(_ onCompleted: @escaping (() -> ())) {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { status, error in
            if let error = error {
                print(error.localizedDescription)
                onCompleted()
                return
            }
            
            RemoteConfig.remoteConfig().activate() { status, error in
                onCompleted()
            }
        }
    }
    
    func string(forKey key: ValueKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        return RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
}

