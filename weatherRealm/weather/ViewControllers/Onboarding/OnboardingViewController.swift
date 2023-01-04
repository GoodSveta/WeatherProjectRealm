//
//  OnboardingViewController.swift
//  weather
//
//  Created by mac on 4.05.22.
//

import UIKit
import LTMorphingLabel
import NVActivityIndicatorView



class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var labelWeather: LTMorphingLabel!
    var timerInterstitial: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        setupUI()
        
        RCManager.shared.connect { [weak self] in
            DispatchQueue.main.async {
                self?.pushVC()
                self?.settingMainTabBarController()
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    private func setupUI() {
        labelWeather.text = NSLocalizedString("tabBarItem_title_weather", comment: "")
        labelWeather.morphingEffect = .scale
        labelWeather.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
    }
    
    private func pushVC() {
        UIView.animate(withDuration: 0.5) {
            self.labelWeather.alpha = 0
        }
    }
    
    private func settingMainTabBarController() {
        guard let mainTabBarVC = MainTabBarViewController.getInstanceViewController as? MainTabBarViewController,
              var viewControllers = mainTabBarVC.viewControllers,
              let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        else {return}
        
        if RCManager.shared.string(forKey: .mapType) == "apple" {
            if let appleMacVC = MapViewController.getInstanceViewController {
                viewControllers.append(appleMacVC)
            }
        } else {
            if let googleMapVC = GoogleMapViewController.getInstanceViewController {
                viewControllers.append(googleMapVC)
            }
        }
        if RCManager.shared.bool(forKey: .showNews) {
            if let newsVC = NewsViewController.getInstanceViewController {
                viewControllers.append(newsVC)
            }
        }
        
        mainTabBarVC.viewControllers = viewControllers
        keyWindow.rootViewController = mainTabBarVC
        keyWindow.makeKeyAndVisible()
        
    }
}


