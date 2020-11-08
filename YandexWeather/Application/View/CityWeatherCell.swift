//
//  CityWeatherCell.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 04.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class CityWeatherCell: UITableViewCell {
    
    let dayNameLabel = UILabel(frame: .zero)
    let weatherIconImageView = UIImageView()
    let temperatureMaxLabel = UILabel(frame: .zero)
    let temperatureMinLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setSubviews()
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setSubviews() {
        
        self.addSubview(dayNameLabel)
        self.addSubview(weatherIconImageView)
        self.addSubview(temperatureMaxLabel)
        self.addSubview(temperatureMinLabel)
        self.backgroundColor = .white
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dayNameLabel.numberOfLines = 1
        dayNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        dayNameLabel.textAlignment = .left
        dayNameLabel.textColor = .black
        
        temperatureMaxLabel.numberOfLines = 1
        temperatureMaxLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        temperatureMaxLabel.textAlignment = .center
        temperatureMaxLabel.textColor = .black
        
        temperatureMinLabel.numberOfLines = 1
        temperatureMinLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        temperatureMinLabel.textAlignment = .center
        temperatureMinLabel.textColor = .black
        
        weatherIconImageView.contentMode = .scaleAspectFit
      //  weatherIconImageView.layer.cornerRadius = self.frame.size.height / 16
        weatherIconImageView.layer.masksToBounds = true
        
        
        dayNameLabel.pin.start(10.0.scaled)
            .vCenter()
            .sizeToFit()
        
        temperatureMinLabel.pin
            .right(10.0.scaled)
            .vCenter()
            .sizeToFit()
        
        temperatureMaxLabel.pin
            .right(40.0.scaled)
            .sizeToFit()
            .vCenter()
        
        weatherIconImageView.pin
            .vCenter()
            .hCenter()
            .width(self.frame.height-15.scaled)
            .height(self.frame.height-15.scaled)
                
    }
    
}
