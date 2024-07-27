//
//  UIButton.Configuration+.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import UIKit

extension UIButton.Configuration {
    static var sortButtonConfig: UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageType.sort
        configuration.baseForegroundColor = .black
        configuration.background.cornerRadius = 14
        configuration.baseBackgroundColor = .white
        configuration.background.strokeColor = .light_gray
        configuration.background.strokeWidth = 1
        return configuration
    }
    
    static var mbtiButtonConfig: UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 22
        configuration.background.strokeColor = .dark_gray
        configuration.background.strokeWidth = 1
        configuration.baseForegroundColor = .dark_gray
        return configuration
    }
}
