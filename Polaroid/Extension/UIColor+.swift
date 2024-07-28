//
//  UIColor+.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit

extension UIColor {
    static let theme_blue = UIColor(red: 24/255, green: 111/255, blue: 242/255, alpha: 1.0)
    static let dark_gray = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
    static let deep_gray = UIColor(red: 77/255, green: 86/255, blue: 82/255, alpha: 1.0)
    static let black = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static let light_gray = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    static let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let coral = UIColor(red: 240/255, green: 68/255, blue: 82/255, alpha: 1.0)
    
    convenience init(rgb: UInt) {
       self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
