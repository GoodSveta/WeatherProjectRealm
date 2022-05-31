//
//  NewsViewController.swift
//  weather
//
//  Created by mac on 24.03.22.
//

import UIKit
import GoogleMobileAds

class NewsViewController: UIViewController {
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private var news: WelcomeNews? {
        didSet {
                self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        activityIndicator.startAnimating()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNews()
    }
    
    private func getNews() {
        NetworkServiceManager.shared.getNews() { [weak self] welcomeNews in
            self?.news = welcomeNews
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
               
            }

        } onError: { [weak self] error in
            guard let error = error else { return }
            self?.showAllert(with: error)
        }
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NewsTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTitleTableViewCell")
    }
}
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitleTableViewCell") as? NewsTitleTableViewCell, let news = news else { return UITableViewCell() }
        cell.setupNews(with: news.articles[indexPath.row])
        return cell
    }
}
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = AllNewsViewController.getInstanceViewController as? AllNewsViewController  else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.newsAll = news?.articles[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension NewsViewController: GADFullScreenContentDelegate {
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
