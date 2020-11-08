//
//  NetworkMonitor.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 06.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//
//import Network
//
//class NetworkMonitor {
//
//    let monitor = NWPathMonitor()
//
//    func NetworkStatus() {
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("We're connected!")
//            } else {
//                print("No connection.")
//            }
//
//            print(path.isExpensive)
//        }
//
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
//    }
//}
