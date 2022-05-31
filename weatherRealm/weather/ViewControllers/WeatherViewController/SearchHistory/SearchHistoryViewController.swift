//
//  SearchHistoryViewController.swift
//  weather
//
//  Created by mac on 16.04.22.
//

import UIKit
import CoreData
import Lottie
import GoogleMobileAds

class SearchHistoryViewController: UIViewController {
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var backButton: UIButton!
    private var historyCity: [Welcome] = []
    private var historyMap: [Welcome] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
        animationViewDelete()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationViewDelete()
    }
    
    private func animationViewDelete() {
        let jsonName = "15120-delete"
        let animation = Animation.named(jsonName)
        let animationView = AnimationView(animation: animation)
        let sizeWidth = lottieView.frame.size.width
        let sizeHeight = lottieView.frame.size.height
        animationView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeWidth, height: sizeHeight))
        animationView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
    }
    
    private func setupUI() {
        segmentedControl.layer.cornerRadius = 15
        tableView.layer.cornerRadius = 15
        backButton.setTitle(NSLocalizedString("button_back_text", comment: ""), for: .normal)
        segmentedControl.setTitle(NSLocalizedString("segment_city_text", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("segment_map_text", comment: ""), forSegmentAt: 1)
    }
    
    @IBAction func choiceSegment(_ sender: UISegmentedControl) {
        fetchRequest()
    }
    
    func fetchRequest() {
        if segmentedControl.selectedSegmentIndex == 0 {
            historyCity.removeAll()
            let citySource = CoreDataManager.shared.getWeatherFromDB(source: SourceType.wearherCity.rawValue)
            historyCity.append(contentsOf: citySource)
            tableView.reloadData()
        } else {
            historyMap.removeAll()
            let mapSource = CoreDataManager.shared.getWeatherFromDB(source: SourceType.weatherMap.rawValue)
            historyMap.append(contentsOf: mapSource)
            tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchHistoryCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchHistoryCityTableViewCell")
        tableView.register(UINib(nibName: "SearchHistoryMapTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchHistoryMapTableViewCell")
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        CoreDataManager.shared.cleareDataBase()
        historyCity.removeAll()
        historyMap.removeAll()
        buttonDelete.isHidden = true
        lottieView.alpha = 0
        tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return historyCity.count
        case 1: return historyMap.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCityTableViewCell") as? SearchHistoryCityTableViewCell else { return UITableViewCell() }
            cell.getWeatherDB(with: historyCity[indexPath.row], source: .wearherCity)
            cell.clickDeleteRow = { [weak self] in
                self?.fetchRequest() }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryMapTableViewCell") as? SearchHistoryMapTableViewCell else { return UITableViewCell() }
            cell.getWeatherDB(with: historyMap[indexPath.row], source: .weatherMap)
            cell.clickDeleteRow = { [weak self] in
                self?.fetchRequest() }
            cell.selectionStyle = .none
            return cell
            default: return UITableViewCell()
        }
    }
}

extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

extension SearchHistoryViewController: GADFullScreenContentDelegate {
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

