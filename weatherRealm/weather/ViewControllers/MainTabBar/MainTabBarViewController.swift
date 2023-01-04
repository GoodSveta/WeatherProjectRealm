//
//  MainTabBarViewController.swift
//  weather
//
//  Created by mac on 24.03.22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    private let localized = ["tabBarItem_title_weather", "tabBarItem_title_map", "tabBarItem_title_news"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tabBar.items?.enumerated().forEach {$0.element.title = NSLocalizedString(self.localized[$0.offset], comment: "")
            }
        }
    }
}
