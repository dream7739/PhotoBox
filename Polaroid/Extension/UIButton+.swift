//
//  UIButton+.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import UIKit

extension UIButton {
    func throttle(){
        isUserInteractionEnabled = false
        let deadLine = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: deadLine){ [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
    
    func setUnderLine(){
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
