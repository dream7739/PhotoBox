//
//  Condition.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import Foundation

enum SortCondition: String {
    case latest
    case relevant
    
    var title: String {
        switch self {
        case .latest:
            return "최신순"
        case .relevant:
            return "관련순"
        }
    }
}
