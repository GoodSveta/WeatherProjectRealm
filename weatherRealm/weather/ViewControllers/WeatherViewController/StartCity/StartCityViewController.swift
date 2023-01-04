//
//  StartCityViewController.swift
//  weather
//
//  Created by mac on 28.03.22.
//

import UIKit
import LTMorphingLabel
import Lottie
import GoogleMobileAds

class StartCityViewController: UIViewController {
    
    @IBOutlet weak var labelWeather: LTMorphingLabel!
    @IBOutlet weak var textFieldText: UITextField!
    @IBOutlet weak var lottieView: UIView!
    var animationView = AnimationView()
    private var interstitial: GADInterstitialAd?
    @IBOutlet weak var buttonHistory: UIButton!
    var clickOk: Bool = false
    var showInterstitial: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animationViewHistory()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationViewHistory()
    }
    
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
            interstitial?.fullScreenContentDelegate = self
            interstitial?.present(fromRootViewController: self)
        })
    }
    
    private func setupUI() {
        labelWeather.morphingEffect = .sparkle
        labelWeather.text = NSLocalizedString("labelWeather_text", comment: "")
        textFieldText.placeholder = NSLocalizedString("textField_text", comment: "")
        buttonHistory.setTitle(NSLocalizedString("buttonHistory_text", comment: ""), for: .normal)
    }
    
    private func animationViewHistory() {
        let jsonName = "buttonHistory"
        let animation = Animation.named(jsonName)
        animationView = AnimationView(animation: animation)
        let sizeWidth = lottieView.frame.size.width
        let sizeHeight = lottieView.frame.size.height
        animationView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeWidth, height: sizeHeight))
        animationView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
    }
    
    @IBAction func buttonClickOk(_ sender: UIButton) {
        loadIntersAds()
        clickOk = true
        TimerADs.sharedTimer.timerInterstitial?.invalidate()
        
    }
    
    @IBAction func buttonClickHictory(_ sender: UIButton) {
        guard let vc = SearchHistoryViewController.getInstanceViewController as? SearchHistoryViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StartCityViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
        if clickOk {
            guard let vc = CityViewController.getInstanceViewController as? CityViewController else { return }
            vc.cityGet = textFieldText.text
            navigationController?.pushViewController(vc, animated: true)
            print("Ad did fail to present full screen content.")
        }
        TimerADs.sharedTimer.timerInterstitial?.invalidate()
        TimerADs.sharedTimer.startTimer()
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if clickOk {
            guard let vc = CityViewController.getInstanceViewController as? CityViewController else { return }
            vc.cityGet = textFieldText.text
            navigationController?.pushViewController(vc, animated: true)
            print("Ad did dismiss full screen content.")
        }
        clickOk = false
        TimerADs.sharedTimer.timerInterstitial?.invalidate()
        TimerADs.sharedTimer.startTimer()
    }
}
