//
//  ConfigurationProvider.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 06/03/2024.
//

import Foundation
import CoreLocation

class ConfigurationProvider: NSObject, ConfigurationProviderProtocol, CLLocationManagerDelegate {
    private var latitude: String?
    private var longitude: String?
    private var clientToken: String = "d4277b87ee5c71a468ec0c3dc311a724"
    
    private let locationManager: CLLocationManager = CLLocationManager()

    var endpoint: String {
        guard let latitude = self.latitude, let longitude = self.longitude else {
            return defaultEndpoint()
        }
        
        let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
        let latitudeParam = "lat=\(latitude)"
        let longitudeParam = "&lon=\(longitude)"
        let clientTokenParam = "&appid=\(clientToken)"
        return baseURL + latitudeParam + longitudeParam + clientTokenParam
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        self.requestLocationAuthorization()
    }
    
    init(latitude: String?, longitude: String?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func requestLocationAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = "\(location.coordinate.latitude)"
            longitude = "\(location.coordinate.longitude)"
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    private func defaultEndpoint() -> String {
        let latitude: String = "34.0194704"
        let longitude: String = "-118.4912273"
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(clientToken)"
    }
}
