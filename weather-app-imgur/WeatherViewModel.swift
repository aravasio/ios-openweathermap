//
//  WeatherViewModel.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 05/03/2024.
//

import UIKit
import SnapKit

class WeatherViewModel: WeatherViewModelProtocol {
    var locationName: String {
        // Return a hardcoded location name
        return "Santa Monica"
    }
    
    var temperature: String {
        // Return a hardcoded temperature value
        return "71°"
    }
    
    var weatherDescription: String {
        // Return a hardcoded weather description
        return "Light rain"
    }
    
    var temperatureRange: String {
        // Return a hardcoded low temperature value
        return "Low: 58° High: 72°"
    }
    
    var windInfo: String {
        // Return a hardcoded wind information value
        return "8.5 mph (135°)"
    }
}
