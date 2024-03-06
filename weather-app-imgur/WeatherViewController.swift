//
//  ViewController.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 05/03/2024.
//

import UIKit

protocol WeatherViewModelProtocol {
    // Protocol properties and methods go here
    // Example properties:
     var locationName: String { get }
     var temperature: String { get }
     var weatherDescription: String { get }
     var temperatureRange: String { get }
     var windInfo: String { get }
}

class WeatherViewController<ViewModel: WeatherViewModelProtocol>: UIViewController {
    
    private let locationLabel = UILabel()
    private let weatherImageView = UIImageView()
    private let temperatureValueLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let windLabel = UILabel()
    private let mainStackView = UIStackView()

    private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("vda")
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        // Configure the main stack view
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 8

        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 24)
        
        temperatureValueLabel.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        temperatureValueLabel.textColor = .white
        
        weatherDescriptionLabel.textAlignment = .center
        weatherDescriptionLabel.textColor = .white
        
        minMaxTempLabel.textAlignment = .center
        minMaxTempLabel.textColor = .white
        
        windLabel.textAlignment = .center
        windLabel.textColor = .white

        mainStackView.addArrangedSubview(locationLabel)
        mainStackView.addArrangedSubview(weatherImageView)
        mainStackView.addArrangedSubview(temperatureValueLabel)
        mainStackView.addArrangedSubview(weatherDescriptionLabel)
        mainStackView.addArrangedSubview(minMaxTempLabel)
        mainStackView.addArrangedSubview(windLabel)

        view.addSubview(mainStackView)
        
        // Set up views with mock data
        locationLabel.text = viewModel.locationName
        weatherImageView.image = UIImage(named: "weather-icon") // Replace with actual image
        temperatureValueLabel.text = "71°"
        weatherDescriptionLabel.text = "Light rain"
        minMaxTempLabel.text = "Low: 58° High: 72°"
        windLabel.text = "Wind: 8.5 (135)"
    }

    private func layoutViews() {
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
    }
}
