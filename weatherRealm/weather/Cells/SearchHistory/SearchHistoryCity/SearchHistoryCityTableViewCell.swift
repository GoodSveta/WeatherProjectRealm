//
//  SearchHistoryCityTableViewCell.swift
//  weather
//
//  Created by mac on 18.04.22.
//

import UIKit
import CoreData

class SearchHistoryCityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerAction: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelTempMax: UILabel!
    @IBOutlet weak var labelFeelsLike: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var imageViewAction: UIImageView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    var date: Int64?
    var clickDeleteRow: (() -> ())?
    var images: [UIImage] = []
    lazy var animationDuration = {
        return Double(images.count) / 18.0
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationImage()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_ :)))
        panGesture.delegate = self
        containerView.addGestureRecognizer(panGesture)
    }
    
    private func animationImage() {
        for i in 0...47 {
            if let image = UIImage(named: "n_\(i)") {
                images.append(image)
            }
        }
        imageViewAction.animationImages = images
        imageViewAction.animationRepeatCount = 100
        imageViewAction.animationDuration = animationDuration
        imageViewAction.startAnimating()
    }
    
    @objc private func panGestureAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: containerView)
            sender.setTranslation(.zero, in: containerView)
            guard translation.x < 0 || containerView.frame.origin.x < 0 else { return }
            containerView.frame.origin.x += translation.x
            imageViewAction.startAnimating()
        case .cancelled, .ended, .failed:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                if self.containerView.frame.origin.x < -self.containerAction.bounds.width {
                    self.containerView.frame.origin.x = -self.containerAction.bounds.width
                } else {
                    if self.containerView.frame.origin.x > 0 {
                        self.containerView.frame.origin.x = 0
                    } else {
                        if abs(self.containerView.frame.origin.x) > (self.containerAction.bounds.width/2) {
                            self.containerView.frame.origin.x = -self.containerAction.bounds.width
                        } else {
                            self.containerView.frame.origin.x = 0
                        }
                    }
                }
            }
        default: break
        }
    }
    
    func getWeatherDB(with weather: Welcome, source: SourceType = .wearherCity) {
        labelName.text = weather.name
        date = Int64(weather.dt)
        labelDate.text = ServiceManager.shared.unixTimeConvertion(unixTime: Double(weather.dt))
        labelTemp.text = "\(Int(weather.main.temp))°"
        labelTempMax.text = "\(NSLocalizedString("temp_max_text", comment: "")): \(Int(weather.main.tempMax))°"
        labelFeelsLike.text = "\(NSLocalizedString("tempIsFeltLabel_text", comment: "")) \(Int(weather.main.feelsLike))°"
        labelWindSpeed.text = "\(NSLocalizedString("wind_text", comment: "")) \(Int(weather.wind.speed)) m/s"
        labelHumidity.text = "\(NSLocalizedString("humidity_text", comment: "")) \(Int(weather.main.humidity)) %"
        
        FileServiceManager.shared.getImage(from: weather.weather.first?.icon ?? "", completed: {[weak self] image in self?.imageViewIcon.image = image})
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func clickButtonDelete(_ sender: UIButton) {
        CoreDataManager.shared.cleareDBbyDate(date: Int64(date ?? 0))
       
        clickDeleteRow?()
    }
}

