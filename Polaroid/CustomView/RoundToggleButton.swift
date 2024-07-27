//
//  RoundToggleButton.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import UIKit
import SnapKit

final class RoundToggleButton: UIButton {
    var isClicked: Bool = false{
        didSet{
            if isClicked {
                configuration?.background.backgroundColor = .theme_blue
                configuration?.baseForegroundColor = .white
                configuration?.background.strokeColor = .theme_blue
            }else{
                configuration?.background.backgroundColor = .white
                configuration?.baseForegroundColor = .dark_gray
                configuration?.background.strokeColor = .dark_gray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configuration = .mbtiButtonConfig
        snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
