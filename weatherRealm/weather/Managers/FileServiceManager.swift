//
//  FileServiceManager.swift
//  weather
//
//  Created by mac on 26.04.22.
//

import UIKit

class FileServiceManager {
    static let shared = FileServiceManager()
    
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init() {
        print(documentDirectory)
    }
    
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func getImage(from stringUrl: String, completed: @escaping (UIImage?) -> ()) {
        guard let pathImage = API.hostIcon.getIconURL(by: stringUrl) else { return }
        let imageURL = documentDirectory.appendingPathComponent(pathImage.absoluteString)
        
        if !directoryExistsAtPath(imageURL.deletingLastPathComponent().path) {
            do {
                try FileManager.default.createDirectory(atPath: imageURL.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
            } catch (let e) {
                print(e.localizedDescription)
            }
        }
        
        guard let dataImage = FileManager.default.contents(atPath: imageURL.path) else {
            DispatchQueue.global().async {
                guard let url = URL(string: pathImage.absoluteString) else { return }
                if let dataImage = try? Data(contentsOf: url) {
                    do {
                        try dataImage.write(to: imageURL)
                        DispatchQueue.main.async {
                            completed(UIImage(data: dataImage))
                        }
                    } catch (let e) {
                        print(e.localizedDescription)
                    }
                }
            }
            return
        }
        
        completed(UIImage(data: dataImage))
    }
}
