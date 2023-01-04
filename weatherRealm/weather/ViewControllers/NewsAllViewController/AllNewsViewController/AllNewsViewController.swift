//
//  AllNewsViewController.swift
//  weather
//
//  Created by mac on 31.03.22.
//

import UIKit
import GoogleMobileAds

class AllNewsViewController: UIViewController {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewAllNews: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    var newsAll: Article?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let newsAll = newsAll else { return }
        setupNewsAll(with: newsAll)
        
    }
    
    func setupNewsAll(with newsAll: Article) {
        titleLabel.text = newsAll.source.name
        dateLabel.text = newsAll.publishedAt
        contentLabel.text = newsAll.content ?? ""
        authorLabel.text = newsAll.author
        
        DispatchQueue.global().async { [weak self] in
            if let urlToImage = URL(string: newsAll.urlToImage ?? ""),
               let data = try? Data(contentsOf: urlToImage, options: .alwaysMapped) {
                DispatchQueue.main.async {
                    self?.imageViewAllNews.image = UIImage(data: data)
                }
            }
        }
    }
}

extension AllNewsViewController: GADFullScreenContentDelegate {
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
