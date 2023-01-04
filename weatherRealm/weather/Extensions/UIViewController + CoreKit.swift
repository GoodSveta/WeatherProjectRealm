//
//  UIViewController + CoreKit.swift
//  weather
//
//  Created by mac on 24.03.22.
//

import UIKit

extension UIViewController {
    static var getInstanceViewController: UIViewController? {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateInitialViewController()
    }
    
    static func getViewController(with identifier: String) -> UIViewController? {
        return UIStoryboard(name: String(describing: self), bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    func showAllert(with messageError: String) {
        let alert = UIAlertController(title: nil, message: messageError, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
}
