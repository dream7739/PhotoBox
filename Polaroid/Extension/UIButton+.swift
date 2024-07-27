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
}
