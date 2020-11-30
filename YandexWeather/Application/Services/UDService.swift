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
    var placeCount : Int?
  
    init() {
        placeCount = defaults.object(forKey: "PlaceCount") as? Int
        print("\(#function) - placeCount = \(String(describing: placeCount))")
    }
  
    
    // функция кодирования
    func saveToUd(places: [UserPlace]) {
        
        if places.count > 0 {
         //   defaults.removeObject(forKey: "PlaceCount")
            defaults.set(places.count, forKey: "PlaceCount")
            print("\(#function) - places.count = \(places.count)")
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(places) {
        //        defaults.removeObject(forKey: "Places")
                defaults.set(encoded, forKey: "Places")
                print("\(#function) - places encoded = \(encoded)")
            }
        } else {
            defaults.removeObject(forKey: "Places")
            defaults.removeObject(forKey: "PlaceCount")

//            defaults.set(nil, forKey: "PlaceCount")
//            defaults.set(nil, forKey: "Places")
        }
    }
    
    
    // функция декодирования
    func readFromUD() -> [UserPlace] {

        if placeCount != nil && placeCount != 0 {
            if let savedPlaces = defaults.object(forKey: "Places") as? Data {
                print("\(#function) - savedPlaces.cont = \(savedPlaces.count)")
                let decoder = JSONDecoder()
                if let loadedPlaces = try? decoder.decode([UserPlace].self, from: savedPlaces) {
                    return loadedPlaces
                }
            }
        }
        return [UserPlace]()
    }
    
}


    
