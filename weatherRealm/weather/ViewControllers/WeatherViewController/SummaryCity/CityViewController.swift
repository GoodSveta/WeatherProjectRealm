//
//  CityViewController.swift
//  weather
//
//  Created by mac on 24.03.22.
//

import UIKit
import AVKit
import LTMorphingLabel
import NVActivityIndicatorView
import GoogleMobileAds

enum BundleName: String {
    case clear
    case drizzle
    case rain
    case thunder
    case clouds
    case snow
    case atmosphere
    case birds
}

enum WeatherType: String {
    case Clouds
    case Clear
    case Thunderstorm
    case Rain
    case Snow
    case Atmosphere
    case Drizzle
}

class CityViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var cityLabel: LTMorphingLabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempIsFeltLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    var date: Int64?
    var cityGet: String?
    var playerAudio: AVPlayer? {
        didSet {
            DispatchQueue.main.async { self.playerAudio?.play() }
        }
    }
    
    var playerVideo: AVPlayer? {
        didSet {
            DispatchQueue.main.async { self.playerVideo?.play() }
        }
    }
    
    var backgroundVideoLayer: AVPlayerLayer?
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    private var weatherCity: Welcome? {
        didSet{
            DispatchQueue.main.async { [self] in
                guard let weatherCity = self.weatherCity else { return }
                setup(with: weatherCity)
                guard let weatherCity = self.weatherCity else { return }
                setupVideo(with: weatherCity)
                guard let weatherCity = self.weatherCity else { return }
                setupAudio(with: weatherCity)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        activityIndicatorView.startAnimating()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeather()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearMediaObjects()
    }
    
    func setupUI() {
        cityLabel.text = cityGet
        cityLabel.morphingEffect = .sparkle
        backButton.setTitle(NSLocalizedString("button_back_text", comment: ""), for: .normal)
    }
    
    func setupVideoURL() -> URL? {
        var urlVideo: URL?
        guard let name = weatherCity?.weather.first?.main, let type = WeatherType(rawValue: name) else {return nil}
        
        switch type {
        case .Clear: urlVideo = Bundle.main.url(forResource: BundleName.clear.rawValue, withExtension: "mp4")
        case .Atmosphere: urlVideo = Bundle.main.url(forResource: BundleName.atmosphere.rawValue, withExtension: "mp4")
        case .Clouds: urlVideo = Bundle.main.url(forResource: BundleName.clouds.rawValue, withExtension: "mp4")
        case .Drizzle: urlVideo = Bundle.main.url(forResource: BundleName.drizzle.rawValue, withExtension: "mp4")
        case .Rain: urlVideo = Bundle.main.url(forResource: BundleName.rain.rawValue, withExtension: "mp4")
        case .Snow: urlVideo = Bundle.main.url(forResource: BundleName.snow.rawValue, withExtension: "mp4")
        case .Thunderstorm: return Bundle.main.url(forResource: BundleName.thunder.rawValue, withExtension: "mp4")
        }
        return urlVideo
    }
    
    func setupAudioURL() -> URL? {
        var urlAudio: URL?
        guard let name = weatherCity?.weather.first?.main, let type = WeatherType(rawValue: name) else {return nil}
        
        switch type {
        case .Clear: urlAudio = Bundle.main.url(forResource: BundleName.birds.rawValue, withExtension: "mp3")
        case .Atmosphere: urlAudio = Bundle.main.url(forResource: BundleName.birds.rawValue, withExtension: "mp3")
        case .Clouds: urlAudio = Bundle.main.url(forResource: BundleName.birds.rawValue, withExtension: "mp3")
        case .Drizzle: urlAudio = Bundle.main.url(forResource: BundleName.rain.rawValue, withExtension: "mp3")
        case .Rain: urlAudio = Bundle.main.url(forResource: BundleName.rain.rawValue, withExtension: "mp3")
        case .Snow: urlAudio = Bundle.main.url(forResource: BundleName.birds.rawValue, withExtension: "mp3")
        case .Thunderstorm: urlAudio = Bundle.main.url(forResource: BundleName.thunder.rawValue, withExtension: "mp3")
        }
        return urlAudio
    }
    
    func setupVideo(with weatherCity: Welcome) {
        guard let url = setupVideoURL() else { return }
        let playerItem = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerVideo?.currentItem)
        
        playerVideo = AVPlayer(playerItem: playerItem)
        backgroundVideoLayer = AVPlayerLayer(player: playerVideo)
        backgroundVideoLayer?.frame = videoView.frame
        backgroundVideoLayer?.videoGravity = .resizeAspectFill
        videoView.layer.insertSublayer(backgroundVideoLayer!, at: 0)
        playerVideo?.play()
    }
    
    private func setupAudio(with weatherCity: Welcome) {
        guard let url = setupAudioURL() else { return }
        let playerItem = AVPlayerItem(url: url)
        playerAudio = AVPlayer(playerItem: playerItem)
        playerAudio?.play()
    }
    
    @objc func videoDidEnd(_ notification: Notification) {
        playerVideo?.seek(to: .zero)
        playerVideo?.play()
    }
    
    func clearMediaObjects() {
        playerVideo?.pause()
        playerAudio?.pause()
        backgroundVideoLayer?.removeFromSuperlayer()
        playerVideo = nil
        playerAudio = nil
        backgroundVideoLayer = nil
    }
    
    private func getWeather() {
        NetworkServiceManager.shared.getWeather(with: cityGet ?? "Minsk") { [weak self] welcome in self?.weatherCity = welcome
            self?.activityIndicatorView.stopAnimating()
            CoreDataManager.shared.addWeather(by: welcome, source: SourceType.wearherCity)
        } onError: { [weak self] error in
            guard let error = error else { return }
            self?.showAllert(with: error)
        }
    }
    
    func setup(with weatherCity: Welcome) {
        date = Int64(weatherCity.dt)
        timeLabel.text = ServiceManager.shared.unixTimeConvertion(unixTime: Double(weatherCity.dt))
        tempLabel.text = "\(Int(weatherCity.main.temp))°"
        tempIsFeltLabel.text = "\(NSLocalizedString("tempIsFeltLabel_text", comment: "")) \(Int(weatherCity.main.feelsLike))°"
        windLabel.text = "\(Int(weatherCity.wind.speed)) m/s"
        humidityLabel.text = "\(Int(weatherCity.main.humidity))%"
        tempMaxLabel.text = "\(Int(weatherCity.main.tempMax))°"
        cloudLabel.text = "\(Int(weatherCity.clouds.all))%"
        
        FileServiceManager.shared.getImage(from: weatherCity.weather.first?.icon ?? "", completed: {[weak self] image in self?.imageViewIcon.image = image})
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CityViewController: GADFullScreenContentDelegate {
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
