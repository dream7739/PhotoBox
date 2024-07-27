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
    
    init(title: String){
        super.init(frame: .zero)
        setButtonConfiguration(title)
        setButtonSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtonConfiguration(_ title: String){
        configuration = .mbtiButtonConfig
        configuration?.title = title
    }
    
    private func setButtonSize(){
        snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
}
