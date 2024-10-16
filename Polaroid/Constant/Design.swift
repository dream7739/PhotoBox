//
//  Design.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit

enum Design {
    enum FontType {
        static let primary = UIFont.systemFont(ofSize: 16)
        static let secondary = UIFont.systemFont(ofSize: 15)
        static let tertiary = UIFont.systemFont(ofSize: 14)
        static let quaternary = UIFont.systemFont(ofSize: 13)
        static let primary_bold = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let secondary_bold = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let tertiary_bold = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let quarternary_bold = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }

    enum ImageType {
        static let like_circle = UIImage(named: "like_circle")!
        static let like_circle_inactive = UIImage(named: "like_circle_inactive")!
        static let like = UIImage(systemName: "heart")!
        static let like_selected = UIImage(systemName: "heart.fill")!
        static let sort = UIImage(named: "sort")!
        static let launch = UIImage(named: "launch")!
        static let launchImage = UIImage(named: "launchImage")!
        static let star = UIImage(systemName: "star.fill")!
        static let wifi = UIImage(systemName: "wifi")
    }

    enum TabImage {
        static let tab_trend_inactive = UIImage(named: "tap_trend_inactive")!
        static let tab_trend = UIImage(named: "tab_trend")!
        static let tab_random_inactive = UIImage(named: "tab_random_inactive")!
        static let tab_random = UIImage(named: "tab_random")!
        static let tab_search_inactive = UIImage(named: "tab_search_inactive")!
        static let tab_search = UIImage(named: "tab_search")!
        static let tab_like_inactive = UIImage(named: "tab_like_inactive")!
        static let tab_like = UIImage(named: "tab_like")!
    }


    enum ProfileType: String, CaseIterable {
        case profile_0
        case profile_1
        case profile_2
        case profile_3
        case profile_4
        case profile_5
        case profile_6
        case profile_7
        case profile_8
        case profile_9
        case profile_10
        case profile_11
        
        static var randomTitle: String {
            return ProfileType.allCases.randomElement()!.rawValue
        }

    }
}


