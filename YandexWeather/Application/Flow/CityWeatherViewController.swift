//
//  CityWeatherViewController.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 04.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import SVGKit

class CityWeatherViewController: UIViewController {
    
    private let identifire = "cityWeatherCell"
    private var tableView = UITableView()
    private var header = CityWeatherTableHeader()
    private var footer = CityWeatherTableFooter()
    private var headerHeight = CGFloat()
    
    var place = UserPlace() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.reloadHeaderAndFooter()
                self.title = self.getDayInfo(dateString: self.place.weather.forecasts[0].date, dateFormat: "EEEE" ) + ", " + self.getDayInfo(dateString: self.place.weather.forecasts[0].date, dateFormat: "dd MMMM")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        self.view.backgroundColor = .systemYellow
        
    }
    
    
    func reloadHeaderAndFooter() {
        
        if self.place.weather.forecasts.count > 0 {
            footer.sinriseNameLabel.text = "рассвет"
            footer.sunsetNameLabel.text = "закат"
            footer.humidityNameLabel.text = "влажность"
            footer.windNameLabel.text = "скорость ветра"
            
            header.objectNameLabel.text = self.place.name
            header.objectDescriptionLabel.text = self.place.title
            header.temperatureLabel.text = String(self.place.weather.temp) + "°"
            header.weatherIconImageView.image = self.place.weather.weatherImage
            
            footer.sinriseLabel.text = String(self.place.weather.forecasts[0].sunrise)
            footer.sunsetLabel.text = String(self.place.weather.forecasts[0].sunset)
            footer.humidityLabel.text = String(self.place.weather.forecasts[0].humidity) + " %"
            footer.windLabel.text = String(self.place.weather.forecasts[0].wind_speed) + " m/s"
            
            headerHeight = header.getHeight()
            header.setNeedsLayout()
            footer.setNeedsLayout()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = .none
        view.addSubview(tableView)
        self.tableView.register(CityWeatherCell.self, forCellReuseIdentifier: identifire)
        
    }
    
}

extension CityWeatherViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0.scaled
    }
    
}

extension CityWeatherViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? CityWeatherCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        if self.place.weather.forecasts.count > indexPath.row {
            cell.dayNameLabel.text = getDayInfo(dateString: self.place.weather.forecasts[indexPath.row].date, dateFormat: "EEEE")
            cell.temperatureMaxLabel.text = String(self.place.weather.forecasts[indexPath.row].temp_max)
            cell.temperatureMinLabel.text = String(self.place.weather.forecasts[indexPath.row].temp_min)
            cell.weatherIconImageView.image = self.place.weather.forecasts[indexPath.row].weatherImage
        }
        return cell
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       print(header.getHeight())
        return headerHeight
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
    }
    
    func getDayInfo(dateString : String, dateFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return "Good day" }
        dateFormatter.dateFormat = dateFormat//"EEEE"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    
}

