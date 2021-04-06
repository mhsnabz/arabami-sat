//
//  Reachability.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 6.04.2021.
//


import Network

public class Reachability {
    let internetMonitor = NWPathMonitor()
    let internetQueue = DispatchQueue(label: "InternetMonitor")
    private var hasConnectionPath = false
    func startInternetTracking() {
        // only fires once
        guard internetMonitor.pathUpdateHandler == nil else {
            return
        }
        internetMonitor.pathUpdateHandler = { update in
            if update.status == .satisfied {
                print("Internet connection on.")
                self.hasConnectionPath = true
            } else {
                print("no internet connection.")
                self.hasConnectionPath = false
            }
        }
        internetMonitor.start(queue: internetQueue)
    }

    /// will tell you if the device has an Internet connection
    /// - Returns: true if there is some kind of connection
    func hasInternet() -> Bool {
        return hasConnectionPath
    }
}
