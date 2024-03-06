//
//  WeatherViewModel.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 05/03/2024.
//

import UIKit
import Combine

protocol ConfigurationProviderProtocol {
    var latitude: String { get }
    var longitude: String { get }
    var clientToken: String { get }
}

class WeatherViewModel: WeatherViewModelProtocol {
    private var cancellables: Set<AnyCancellable> = []

    var weatherPublisher: PassthroughSubject<CurrentWeather?, Never> = PassthroughSubject()
    
    let configurationProvider: ConfigurationProviderProtocol
    
    private var currentWeatherEndpoint: String {
        let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
        let latitude = "lat=\(configurationProvider.latitude)"
        let longitude = "&lon=\(configurationProvider.longitude)"
        let clientToken = "&appid=\(configurationProvider.clientToken)"
        return baseURL + latitude + longitude + clientToken
    }
    
    init(configurationProvider: ConfigurationProvider) {
        self.configurationProvider = configurationProvider
    }
    
    func fetchData() {
        fetchSimpleCurrentWeather(
            urlString: currentWeatherEndpoint
        ).sink(
            receiveCompletion: { _ in },
            receiveValue: { newValue in
                self.weatherPublisher.send(newValue)
            }
        ).store(in: &cancellables)
    }
    
    func fetchSimpleCurrentWeather(urlString: String) -> AnyPublisher<CurrentWeather, Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CurrentWeather.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
