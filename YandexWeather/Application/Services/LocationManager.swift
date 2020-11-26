//
//  LocationManager.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 01.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import CoreLocation


class LocationManager: NSObject {
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var getNewLocation: (() -> Void)?


    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       // self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined       : print("didChangeAuthorization: notDetermined")
        case .authorizedWhenInUse :
            self.locationManager.startUpdatingLocation()
            print("didChangeAuthorization: authorizedWhenInUse")
        case .authorizedAlways    :
           // self.locationManager.startUpdatingLocation()
            print("didChangeAuthorization: authorizedAlways")
        case .restricted          : print("didChangeAuthorization: restricted")
        case .denied              : print("didChangeAuthorization: denied")
        @unknown default          : fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0] as CLLocation
    //    manager.allowsBackgroundLocationUpdates = true
        if let callback = self.getNewLocation {
            callback()
        }
    }
    
    
}


extension LocationManager {
    
    // получение координат по названию населенного пункта
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(location)
        }
    }
    
    // получение названия населенного пункта по координатам
       func getPlace(for location: CLLocation,
                     completion: @escaping (CLPlacemark?) -> Void) {
           
           let geocoder = CLGeocoder()
           geocoder.reverseGeocodeLocation(location) { placemarks, error in
               
               guard error == nil else {
                   print("*** Error in \(#function): \(error!.localizedDescription)")
                   completion(nil)
                   return
               }
               
               guard let placemark = placemarks?[0] else {
                   print("*** Error in \(#function): placemark is nil")
                   completion(nil)
                   return
               }
               
               completion(placemark)
           }
       }
    
}
