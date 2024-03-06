//
//  UIImageView+Extension.swift
//  weather-app-imgur
//
//  Created by Alejandro Ravasio on 06/03/2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        activityIndicator.color = .gray
        DispatchQueue.main.async {
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            } else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
        }
    }
}
