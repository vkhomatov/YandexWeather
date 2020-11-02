//
//  ViewController.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 01.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import MapKit


class MainViewController: UIViewController {
    
    let cityVC = CityAddViewController()

    private var tableView = UITableView()
    
    let weather = WeatherService()

    let identifire = "cityCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createTable()
        self.title = "Мои города"
        setupNavbar()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.weather.loadWeatherData(city: "Москва", days: "3")
            self.tableView.reloadData()
        }
    }

    
    private func setupNavbar() {
        
           let addCustomerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                   action: #selector(self.addNewCity))
           self.navigationItem.rightBarButtonItem = addCustomerButton
       }
    
    private func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)

        //self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.sizeToFit()

        view.addSubview(tableView)
    }
    

    
    @objc private func addNewCity() {
    
        present(cityVC, animated: true, completion: nil)
        print("push addNewCity")

    }

}


extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("push \(indexPath.row)")
        
    }
    
}

extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
               cell.selectionStyle = .none
               cell.textLabel?.text = "Город 1"
               return cell
    }
    
    
}

extension MainViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        print("textSearched = \(textSearched)")
    }
}
