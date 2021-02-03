//
//  ViewController.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 01.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
//import MapKit
//import SVGKit


class MainViewController: UIViewController {
    
    private let model = MainViewModel(daysCount: "7")
    // private let udService = UDService()
    
    private var tableView = UITableView()
    private let identifire = "cityCell"
    private var refreshControl = UIRefreshControl()
    // private var udService : UDService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // model.readPlacesUD(places: model.places)
        self.title = "Моя погода"
        createTable()
        setupNavbar()        
        setupRefresh()
        loading()
        
        
        if model.udService.placeCount != nil  {
            model.places = model.udService.readFromUD()
            print("\(#function) -  model.places.count = \(model.places.count)")
            getNewWeather()
            //  print("model.udService.readFromUD().count = \(model.udService.readFromUD().count)")
        } else {
            // print("model.udService.readFromUD().count = \(model.udService.readFromUD().count)")
            model.locationManager.requestLocation()
            model.getCurrentLocation()
        }
        
        model.addWeather()
        
    }
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        print("ЖОПА")
    //    }
    
    private func setupNavbar() {
        let addCustomerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewCity))
        self.navigationItem.rightBarButtonItem = addCustomerButton
    }
    
    
    private func setupRefresh() {
        refreshControl.addTarget(self, action:  #selector(getNewWeather), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .systemYellow
    }
    
    
    private func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = .none
        view.addSubview(tableView)
        self.tableView.register(MainCityCell.self, forCellReuseIdentifier: identifire)
    }
    
    private func loading() {
        
        DispatchQueue.main.async {
            self.model.updateTableView = { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.title = "Моя погода"
            }
        }
        
        DispatchQueue.main.async {
            self.model.updateVCTitle = { [weak self] in
                guard let self = self else { return }
                self.title = "Загрузка данных ..."
            }
        }
    }
    
    @objc private func getNewWeather() {
        
        for place in model.places {
            model.cityWeatherLoad(place: place, days: model.forecastDays)
        }
        
        tableView.refreshControl?.endRefreshing()
    }
    
    
    @objc private func addNewCity() {
        present(model.cityAddVC, animated: true, completion: nil)
    }
    
}



extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if model.places.count > indexPath.section && model.places[indexPath.section].weather.forecasts.count > 0 {
            model.cityWeatherVC.place = model.places[indexPath.section]
               navigationController?.pushViewController(model.cityWeatherVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if model.places.count > indexPath.section {
                model.places.remove(at: indexPath.section)
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}


extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? MainCityCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        if model.places.count > indexPath.section {
            cell.objectNameLabel.text = model.places[indexPath.section].name
            cell.objectDescriptionLabel.text = model.places[indexPath.section].title
            cell.temperatureLabel.text = String(model.places[indexPath.section].weather.temp) + "°"
            cell.weatherIconImageView.image = model.places[indexPath.section].weather.weatherImage
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.places.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}





//extension CLPlacemark {
//    var formattedAddress: String? {
//        guard let postalAddress = postalAddress else {
//            return nil
//        }
//        let formatter = CNPostalAddressFormatter()
//        print(
//            postalAddress.city,
//            postalAddress.country,
//            postalAddress.subLocality,
//            postalAddress.subAdministrativeArea,
//            postalAddress.state)
//        return formatter.string(from: postalAddress)
//    }

//
//func showEnterError() {
//    let alert = UIAlertController(title: "Error!", message: "Введены неверные пользовательские данные", preferredStyle: .alert)
//    let action = UIAlertAction(title: "OK", style: .default)
//    alert.addAction(action)
//
//    present(alert, animated: true)
//}

//func addDoneButtonOnKeyboard() {
//       let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50.0))
//       doneToolbar.barStyle = .default
//
//       let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//       let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized,
//                                                   style: .done,
//                                                   target: self,
//                                                   action: #selector(self.hideKeyboard))
//       done.tintColor = .electricBlue
//
//       let items = [flexSpace, done]
//       doneToolbar.items = items
//       doneToolbar.sizeToFit()
//
//       self.inputAccessoryView = doneToolbar
//   }
