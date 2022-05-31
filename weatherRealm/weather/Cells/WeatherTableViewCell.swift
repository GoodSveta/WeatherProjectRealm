//
//  WeatherTableViewCell.swift
//  weather
//
//  Created by mac on 27.03.22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
//    func setup(with weather: Welcome) {
//        cityLabel.text = "Minsk"
//        tempLabel.text = "\(weather.main.temp)"
//        pressureLabel.text = "\(weather.main.pressure)"
//        humidityLabel.text = "\(weather.main.humidity)"
        
        
//    }
    
}
