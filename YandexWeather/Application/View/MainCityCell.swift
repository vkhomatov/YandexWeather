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
    let cloudsView = UIImageView()
    
    
    
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
           self.addSubview(cloudsView)
           
       }
    
    
    override func layoutSubviews() {
           super.layoutSubviews()
//        self.layer.cornerRadius = self.frame.size.height / 16
    //       self.contentView.layer.masksToBounds = true
        self.backgroundColor = .systemYellow
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowOffset = .init(width: 2, height: 2)
//        self.layer.shadowRadius = 2
        
        objectNameLabel.numberOfLines = 2
        objectNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        objectNameLabel.textAlignment = .natural
        objectNameLabel.textColor = .black
       // objectNameLabel.backgroundColor = .none
        
        objectNameLabel.pin.start(10)
      //  .vCenter()
        .top(10)
            .width(self.frame.width/2)
            .sizeToFit(.width)
        
        
        objectDescriptionLabel.numberOfLines = 3
        objectDescriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        objectDescriptionLabel.textAlignment = .left
        objectDescriptionLabel.textColor = .black
       // objectDescriptionLabel.backgroundColor = .none
        
       // let width = self.frame.width/2
        objectDescriptionLabel.pin.below(of: objectNameLabel, aligned: .start)
        //.size(of: objectNameLabel) //(objectNameLabel.bounds.width)
        //.wrapContent()
        .width(self.frame.width/2)
       // .he
            .marginTop(2.0)
            .sizeToFit(.width)

                //  .sizeToFit(.content)
//        objectDescriptionLabel.pin.start(10)
//            .top(20)
//            .sizeToFit(.width)

          
       }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width * 0.97 // get 97% width here
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space

            super.frame = frame

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
