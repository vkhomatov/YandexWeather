//
//  UserPlace.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 27.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import CoreLocation

struct UserPlace: Equatable {
    
    static func == (lhs: UserPlace, rhs: UserPlace) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name  = String()
    var title = String()
    var coordinates = CLLocationCoordinate2D()
 //   var time = String()
    var weather = CityWeather()
//    var coord : Coordinate(from: <#Decoder#>)
//    enum CodingKeys: String, CodingKey {
//          case name, title, coordinates
//       }
    init() {
        
    }
    
    init(place: UDPlace) {
        self.name = place.name
        self.title = place.title
        self.coordinates.latitude = place.latitude
        self.coordinates.longitude = place.longitude
    }
    
    
}

//struct Coordinate: Codable {
//    var latitude: Double
//    var longitude: Double
//    
//    init(coord: CLLocationCoordinate2D) {
//        self.latitude = coord.latitude
//        self.longitude = coord.longitude
//    }
//}

struct UDPlace: Equatable, Codable {
    
    static func == (lhs: UDPlace, rhs: UDPlace) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var title: String
    var latitude: Double
    var longitude: Double
    
    init(place: UserPlace) {
        self.name = place.name
        self.title = place.title
        self.latitude = place.coordinates.latitude
        self.longitude = place.coordinates.longitude
    }
    
}

