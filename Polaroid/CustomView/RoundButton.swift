//
//  RoundButton.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit

final class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        backgroundColor = .theme_blue
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
