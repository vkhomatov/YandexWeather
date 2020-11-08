//
//  MainCityCell.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 02.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import PinLayout


class MainCityCell: UITableViewCell {
    
    let objectNameLabel = UILabel(frame: .zero)
    let objectDescriptionLabel = UILabel(frame: .zero)
    let temperatureLabel = UILabel(frame: .zero)
    let weatherIconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setSubviews()
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setSubviews() {
        
        self.addSubview(objectNameLabel)
        self.addSubview(objectDescriptionLabel)
        self.addSubview(temperatureLabel)
        self.addSubview(weatherIconImageView)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .systemYellow
        
        objectNameLabel.numberOfLines = 2
        objectNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        objectNameLabel.textAlignment = .natural
        objectNameLabel.textColor = .black
        
        objectDescriptionLabel.numberOfLines = 2
        objectDescriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        objectDescriptionLabel.textAlignment = .left
        objectDescriptionLabel.textColor = .black
        
        temperatureLabel.numberOfLines = 1
        temperatureLabel.font = UIFont.systemFont(ofSize: 60, weight: .light)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .black
        
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.layer.cornerRadius = self.frame.size.height / 16
        weatherIconImageView.layer.masksToBounds = true
        
        
        objectNameLabel.pin.start(10)
            .top(10)
            .width(self.frame.width/2)
            .sizeToFit(.width)
        
        objectDescriptionLabel.pin.below(of: objectNameLabel, aligned: .start)
            .width(self.frame.width/2)
            .marginTop(2.0)
            .sizeToFit(.width)
        
        temperatureLabel.pin
            .right(10.0)
            .sizeToFit(.content)
            .vCenter()
        
        weatherIconImageView.pin
            .vCenter()
            .right(120)
            .width(self.frame.height-25)
            .height(self.frame.height-25)
        
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width * 0.97
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            super.frame = frame
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        objectNameLabel.text = nil
        objectDescriptionLabel.text = nil
        temperatureLabel.text = nil
        weatherIconImageView.image = nil
        isUserInteractionEnabled = true
    }
    
    
}
