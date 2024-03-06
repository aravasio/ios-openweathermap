//
//  CurrentWeather.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 05/03/2024.
//
import Foundation
import Combine

struct CurrentWeather: Decodable {
    let name: String
    let temp: Double
    let description: String
    let icon: String
    let tempMin: Double
    let tempMax: Double
    let windSpeed: Double
    let windDeg: Int

    var iconUrl: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }

    private enum CodingKeys: String, CodingKey {
        case name, main, weather, wind
    }
    
    private enum MainKeys: String, CodingKey {
        case temp, tempMin = "temp_min", tempMax = "temp_max"
    }
    
    private enum WindKeys: String, CodingKey {
        case speed, deg
    }
    
    private enum WeatherKeys: String, CodingKey {
        case description, icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temp = try mainContainer.decode(Double.self, forKey: .temp)
        tempMin = try mainContainer.decode(Double.self, forKey: .tempMin)
        tempMax = try mainContainer.decode(Double.self, forKey: .tempMax)
        
        let windContainer = try container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        windSpeed = try windContainer.decode(Double.self, forKey: .speed)
        windDeg = try windContainer.decode(Int.self, forKey: .deg)
        
        var weatherArray = try container.nestedUnkeyedContainer(forKey: .weather)
        if !weatherArray.isAtEnd {
            let firstWeatherContainer = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
            description = try firstWeatherContainer.decode(String.self, forKey: .description)
            icon = try firstWeatherContainer.decode(String.self, forKey: .icon)
        } else {
            description = "Description not available"
            icon = "" // TODO: Provide a default or placeholder value
        }
    }
}
