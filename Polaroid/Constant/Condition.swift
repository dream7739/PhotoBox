//
//  Condition.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import Foundation

enum SearchCondition: String {
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

enum LikeCondition: String {
    case latest
    case earliest
    
    var title: String {
        switch self {
        case .latest:
            return "최신순"
        case .earliest:
            return "과거순"
        }
    }
}

enum ColorCondition: String, CaseIterable {
    case black
    case white
    case yellow
    case red
    case purple
    case green
    case blue
    
    var value: UInt {
        switch self {
        case .black:
            return 0x000000
        case .white:
            return 0xFFFFFF
        case .yellow:
            return 0xFFEF62
        case .red:
            return 0xF04452
        case .purple:
            return 0x9636E1
        case .green:
            return 0x02B946
        case .blue:
            return 0x3C59FF
        }
    }
    
    var title: String {
        switch self {
        case .black:
            "블랙"
        case .white:
            "화이트"
        case .yellow:
            "옐로우"
        case .red:
            "레드"
        case .purple:
            "퍼플"
        case .green:
            "그린"
        case .blue:
            "블루"
        }
    }
}
