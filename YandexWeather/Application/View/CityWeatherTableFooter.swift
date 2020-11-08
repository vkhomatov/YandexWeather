//
//  CityWeatherTableFooter.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 04.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class CityWeatherTableFooter: UIView {
    
    let sinriseNameLabel = UILabel(frame: .zero)
    let sunsetNameLabel = UILabel(frame: .zero)
    let humidityNameLabel = UILabel(frame: .zero)
    let windNameLabel = UILabel(frame: .zero)
    
    let sinriseLabel = UILabel(frame: .zero)
    let sunsetLabel = UILabel(frame: .zero)
    let humidityLabel = UILabel(frame: .zero)
    let windLabel = UILabel(frame: .zero)
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
        
        self.backgroundColor = .systemYellow
        
        sinriseNameLabel.numberOfLines = 1
        sinriseNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        sinriseNameLabel.textAlignment = .center
        sinriseNameLabel.textColor = .black
        
        sunsetNameLabel.numberOfLines = 1
        sunsetNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        sunsetNameLabel.textAlignment = .center
        sunsetNameLabel.textColor = .black
        
        humidityNameLabel.numberOfLines = 1
        humidityNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        humidityNameLabel.textAlignment = .center
        humidityNameLabel.textColor = .black
        
        windNameLabel.numberOfLines = 1
        windNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        windNameLabel.textAlignment = .center
        windNameLabel.textColor = .black
        
        sinriseLabel.numberOfLines = 1
        sinriseLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        sinriseLabel.textAlignment = .right
        sinriseLabel.textColor = .black
        
        sunsetLabel.numberOfLines = 1
        sunsetLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        sunsetLabel.textAlignment = .right
        sunsetLabel.textColor = .black
        
        humidityLabel.numberOfLines = 1
        humidityLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        humidityLabel.textAlignment = .right
        humidityLabel.textColor = .black
        
        windLabel.numberOfLines = 1
        windLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        windLabel.textAlignment = .right
        windLabel.textColor = .black
        
        
        sinriseNameLabel.pin.start(10.0.scaled)
            .top(10.0.scaled)
            .sizeToFit()
        
        sunsetNameLabel.pin.below(of: sinriseNameLabel, aligned: .start)
            .marginTop(10.0.scaled)
            .sizeToFit()
        
        humidityNameLabel.pin.below(of: sunsetNameLabel, aligned: .start)
            .marginTop(10.0.scaled)
            .sizeToFit()
        
        windNameLabel.pin.below(of: humidityNameLabel, aligned: .start)
            .marginTop(10.0.scaled)
            .sizeToFit()
        
        
        sinriseLabel.pin
            .right(10.0.scaled)
            .top(10.0.scaled)
            .sizeToFit()
        
        sunsetLabel.pin.below(of: sinriseLabel, aligned: .start)
            .marginTop(10.0.scaled)
            .sizeToFit()
        
        humidityLabel.pin.below(of: sunsetLabel, aligned: .start)
            .marginTop(10.0.scaled)
            .sizeToFit()
        
        windLabel.pin.below(of: humidityLabel, aligned: .start)
            .marginTop(10.0.scaled)
            .sizeToFit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  self.backgroundColor = .white
        self.setSubviews()
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setSubviews() {
        
        self.addSubview(sinriseNameLabel)
        self.addSubview(sunsetNameLabel)
        self.addSubview(humidityNameLabel)
        self.addSubview(windNameLabel)
        
        self.addSubview(sinriseLabel)
        self.addSubview(sunsetLabel)
        self.addSubview(humidityLabel)
        self.addSubview(windLabel)
        
        
    }
    
    
}
