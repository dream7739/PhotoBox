//
//  SortOptionButton.swift
//  Polaroid
//
//  Created by 홍정민 on 8/2/24.
//

import UIKit

final class SortOptionButton: ThrottleButton {
    var isClicked = false {
        didSet {
            if isClicked {
                configuration?.title = SearchCondition.latest.title
            }else {
                configuration?.title = SearchCondition.relevant.title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = .sortButtonConfig
        configuration?.title = SearchCondition.relevant.title
    }
}
