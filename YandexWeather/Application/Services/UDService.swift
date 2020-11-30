//
//  UDService.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 29.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

class UDService {
    
    private let defaults = UserDefaults.standard
    private var placesUD = [UDPlace]()
    var placeCount : Int?
  
    init() {
        placeCount = defaults.object(forKey: "PlaceCount") as? Int
        print("\(#function) - placeCount = \(String(describing: placeCount))")
    }
    
    // функция конвертации UserPlase - UDPlace
    private func covertToUD(places: [UserPlace]) -> Int {
        placesUD.removeAll()
        if places.count > 0 {
            for num in 0...places.count-1 {
                placesUD.append(UDPlace(place: places[num]))
            }
            print("\(#function) - covertToUD.count = \(placesUD.count)")
            return placesUD.count
        }
        return 0
    }
    
    
    // функция кодирования
    func saveToUd(places: [UserPlace]) {
        
        if covertToUD(places: places) > 0 {
            defaults.set(placesUD.count, forKey: "PlaceCount")
            print("\(#function) - placesUD.count = \(placesUD.count)")
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(placesUD) {
                defaults.set(encoded, forKey: "Places")
                print ("\(#function) - places encoded = \(encoded)")
            }
        } else {
            defaults.set(nil, forKey: "PlaceCount")
            defaults.set(nil, forKey: "Places")
        }
    }
    
    
    // функция декодирования
    func readFromUD() -> [UserPlace] {

        if placeCount != nil && placeCount != 0 {
            if let savedPlaces = defaults.object(forKey: "Places") as? Data {
                print("\(#function) - savedPlaces.cont = \(savedPlaces.count)")
                let decoder = JSONDecoder()
                if let loadedPlaces = try? decoder.decode([UDPlace].self, from: savedPlaces) {
                    return convertFromUD(udPlaces: loadedPlaces)
                }
            }
        }
        return [UserPlace]()
    }
    
    
    // функция конвертации UDPlace -> UserPlace
    private func convertFromUD(udPlaces: [UDPlace]) -> [UserPlace] {
        var placesUser = [UserPlace]()
        if udPlaces.count > 0 {
            for num in 0...udPlaces.count-1 {
                placesUser.append(UserPlace(place: udPlaces[num]))
            }
            print ("\(#function) - placeUser.count = \(placesUser.count)")
            return placesUser
        }
        return [UserPlace]()
    }
    
}


    
