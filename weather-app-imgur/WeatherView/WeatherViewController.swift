//
//  ViewController.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 05/03/2024.
//

import UIKit
import SnapKit
import Combine

protocol WeatherViewModelProtocol {
    var weatherPublisher: PassthroughSubject<CurrentWeather?, Never> { get }
    func fetchData()
}

class WeatherViewController<ViewModel: WeatherViewModelProtocol>: UIViewController {
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    private let temperatureValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        label.textColor = .white
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let minMaxTempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
        
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        return scrollView
    }()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private var viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    
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
        setupBindings()
        layoutViews()
    }
    
    private func setupViews() {
        mainStackView.addArrangedSubview(locationLabel)
        mainStackView.addArrangedSubview(weatherImageView)
        mainStackView.addArrangedSubview(temperatureValueLabel)
        mainStackView.addArrangedSubview(weatherDescriptionLabel)
        mainStackView.addArrangedSubview(minMaxTempLabel)
        mainStackView.addArrangedSubview(windLabel)
        
        scrollView.refreshControl?.addTarget(self, action: #selector(triggerFetchData), for: .valueChanged)
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        setupSpinner()
        viewModel.fetchData()
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func showSpinner(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            show ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
        }
    }
    
    private func setupBindings() {
        viewModel.weatherPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] weather in
                guard let self = self,
                      let weather = weather
                else { return }
                
                spinner.stopAnimating()
                scrollView.refreshControl?.endRefreshing()

                locationLabel.text = weather.name
                temperatureValueLabel.text = "\(weather.temp)°"
                weatherDescriptionLabel.text = weather.description
                minMaxTempLabel.text = "Low: \(weather.tempMin)° High: \(weather.tempMax)°"
                windLabel.text = "Wind: \(weather.windSpeed) m/s (\(weather.windDeg)°)"
                
                if let icon = weather.iconUrl {
                    weatherImageView.loadImage(from: icon)
                } else {
                    weatherImageView.image = UIImage(systemName: "xmark.octagon")
                }
                
            }
            .store(in: &cancellables)
    }
    
    private func layoutViews() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(scrollView).priority(.low)
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(containerView.snp.top).priority(.high)
            make.bottom.lessThanOrEqualTo(containerView.snp.bottom).priority(.high)
            make.centerX.equalTo(containerView.snp.centerX)
            make.centerY.equalTo(containerView.snp.centerY).priority(.high)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
    }
    
    @objc private func triggerFetchData() {
        spinner.startAnimating()
        viewModel.fetchData()
    }
}
