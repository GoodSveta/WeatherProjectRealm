//
//  TimerADs.swift
//  weather
//
//  Created by mac on 14.05.22.
//

import UIKit
import GoogleMobileAds

class TimerADs: NSObject {
    static let sharedTimer: TimerADs = {
        let timer = TimerADs()
        return timer
    }()

    var timerInterstitial: Timer?
    private var interstitial: GADInterstitialAd?

    func startTimer() {
        timerInterstitial = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { _ in
            self.loadIntersAds()
        }
   )}
    
    func loadIntersAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = UIApplication.shared.topViewController() as? GADFullScreenContentDelegate
            guard let controller = UIApplication.shared.topViewController() else {return}
            interstitial?.present(fromRootViewController: controller)
        })
    }
}
    
extension TimerADs: GADFullScreenContentDelegate {
        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            timerInterstitial?.invalidate()
            startTimer()
            print("Ad did fail to present full screen content.")
        }
        
        func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("Ad will present full screen content.")
        }
        
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            timerInterstitial?.invalidate()
            startTimer()
            print("Ad did dismiss full screen content.")
        }
    }

extension UIApplication {
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

    
    
    
    
    
    
    
