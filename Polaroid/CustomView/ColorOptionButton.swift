//
//  ColorOptionButton.swift
//  Polaroid
//
//  Created by 홍정민 on 7/29/24.
//

import UIKit
import SnapKit

final class ColorOptionButton: UIButton {
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                configuration?.background.backgroundColor = .theme_blue
                configuration?.baseForegroundColor = .white
            }else{
                configuration?.background.backgroundColor = .light_gray
                configuration?.baseForegroundColor = .black
            }
        }
    }
    
    var condition: ColorCondition = .black
    
    init(condition: ColorCondition) {
        super.init(frame: .zero)
        self.condition = condition
        setButtonConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtonConfiguration(){
        configuration = .colorButtonConfig
        configuration?.title = condition.title
        configuration?.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(rgb: condition.value))
    }
    
}
