//
//  ConfigurationProvider.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 06/03/2024.
//

import Foundation

struct ConfigurationProvider: ConfigurationProviderProtocol {
    var latitude: String
    var longitude: String
    var clientToken: String
}
