//
//  MapViewController.swift
//  weather
//
//  Created by mac on 24.03.22.
//

import UIKit
import MapKit
import CoreLocation
import LTMorphingLabel
import GoogleMobileAds
import Lottie


class MapViewController: UIViewController {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var labelRegion: LTMorphingLabel!
    @IBOutlet weak var labelTemp: LTMorphingLabel!
    @IBOutlet weak var labelWind: LTMorphingLabel!
    @IBOutlet weak var tempIsFeltLabel: LTMorphingLabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var mapView: MKMapView!
    var coordinateWeather: Welcome?
    var timer: Timer?
    private let locationManager = CLLocationManager()
    private var interstitial: GADInterstitialAd?
    var animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAds()
        setupUI()
        animationViewLottie()
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationViewLottie()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    func setupAds() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func setupUI() {
        infoView.alpha = 0
        infoView.layer.cornerRadius = 15
        labelRegion.morphingEffect = .evaporate
        labelTemp.morphingEffect = .evaporate
        labelWind.morphingEffect = .evaporate
        tempIsFeltLabel.morphingEffect = .evaporate
    }
    
    private func animationViewLottie() {
        let jsonName = "5733-location-map"
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
    
    private func getCoordinate(by lat: Double?, and lon: Double?) {
        
        NetworkServiceManager.shared.getWeatherCoordinate(by: lat, and: lon) { [weak self] welcome in self?.coordinateWeather = welcome
            CoreDataManager.shared.addWeather(by: welcome, source: SourceType.weatherMap)
        } onError: { [weak self] error in
            guard let error = error else { return }
            self?.showAllert(with: error)
        }
    }
    
    func setup(with coordinateWeather: Welcome?) {
        labelTemp.text = "\(Int(coordinateWeather?.main.temp ?? 0)) C°"
        labelWind.text = "\(NSLocalizedString("wind_text", comment: "")): \(coordinateWeather?.wind.speed ?? 0.0) m/s"
        tempIsFeltLabel.text = "\(NSLocalizedString("tempIsFeltLabel_text", comment: "")) \(Int(coordinateWeather?.main.feelsLike ?? 0))°"
        
        FileServiceManager.shared.getImage(from: coordinateWeather?.weather.first?.icon ?? "", completed: {[weak self] image in self?.imageViewIcon.image = image})
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        mapView.setCenter(location.coordinate, animated: true)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {
            _ in self.getCoordinate(by: mapView.centerCoordinate.latitude, and: mapView.centerCoordinate.longitude)
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.setup(with: self.coordinateWeather)
                    self.infoView.alpha = 1
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)) { placemarks, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        guard let placemark = placemarks?.first else { return }
                        
                        self.labelRegion.text = "\(placemark.locality ?? "unknown")"
                    }
                }})
        })
        infoView.alpha = 0
    }
}

extension MapViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

extension MapViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        TimerADs.sharedTimer.timerInterstitial?.invalidate()
        TimerADs.sharedTimer.startTimer()
        print("Ad did fail to present full screen content.")
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        TimerADs.sharedTimer.timerInterstitial?.invalidate()
        TimerADs.sharedTimer.startTimer()
        print("Ad did dismiss full screen content.")
    }
}








