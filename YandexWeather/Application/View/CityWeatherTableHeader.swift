//
//  CityWeatherTableHeader.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 04.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import PinLayout

class CityWeatherTableHeader: UIView {
    
    let objectNameLabel = UILabel(frame: .zero)
    let objectDescriptionLabel = UILabel(frame: .zero)
    let temperatureLabel = UILabel(frame: .zero)
    let weatherIconImageView = UIImageView()

    
  //  var height : CGFloat = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .systemYellow
        setupViews()
    }
    
    
    private func setupViews() {
        
        objectNameLabel.numberOfLines = 2
        objectNameLabel.allowsDefaultTighteningForTruncation = false
        objectNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        objectNameLabel.textAlignment = .center
        objectNameLabel.textColor = .black
        
        objectDescriptionLabel.numberOfLines = 2
        objectNameLabel.allowsDefaultTighteningForTruncation = false
        objectDescriptionLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        objectDescriptionLabel.textAlignment = .center
        objectDescriptionLabel.textColor = .black
        
        temperatureLabel.numberOfLines = 1
        temperatureLabel.font = UIFont.systemFont(ofSize: 60, weight: .light)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .black
        
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.layer.masksToBounds = true
        weatherIconImageView.layer.opacity = 0.25
              
        
        objectNameLabel.pin
           // .hCenter()
            .top(10.0)
            .width(self.frame.width)
            .sizeToFit(.width)
        
        temperatureLabel.pin.below(of: objectNameLabel, aligned: .center)
            .marginTop(10.0)
           // .hCenter()
            .sizeToFit()
        
        objectDescriptionLabel.pin.below(of: temperatureLabel, aligned: .center)
           // .hCenter()
            .marginTop(10.0)
            .width(self.frame.width)
            .sizeToFit(.width)
        
        weatherIconImageView.pin
            .size(of: self)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubviews()
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setSubviews() {
        
        self.addSubview(weatherIconImageView)
        self.addSubview(objectNameLabel)
        self.addSubview(objectDescriptionLabel)
        self.addSubview(temperatureLabel)
        
    }
    
    func getHeight() -> CGFloat {
        setupViews()
        return objectNameLabel.frame.height + objectDescriptionLabel.frame.height + 115.0
    }
    
    
}
