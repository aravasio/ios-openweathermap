//
//  WeatherViewModel.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 05/03/2024.
//

import UIKit
import Combine

protocol ConfigurationProviderProtocol {
    var endpoint: String { get }
}

class WeatherViewModel: WeatherViewModelProtocol {
    private var cancellables: Set<AnyCancellable> = []

    var weatherPublisher: PassthroughSubject<WeatherResult, Never> = PassthroughSubject()
    
    let configurationProvider: ConfigurationProviderProtocol
    
    init(configurationProvider: ConfigurationProvider) {
        self.configurationProvider = configurationProvider
    }
    
    func fetchData() {
        fetchSimpleCurrentWeather(
            urlString: configurationProvider.endpoint
        ).sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.weatherPublisher.send(.failure(error))
                }
            },
            receiveValue: { newValue in
                self.weatherPublisher.send(.success(newValue))
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
