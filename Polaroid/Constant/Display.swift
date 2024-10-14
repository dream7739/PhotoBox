//
//  Display.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

enum Navigation {
    case profile
    case editProfile
    case topicPhoto
    case searchPhoto
    case likePhoto
    
    var title: String {
        switch self {
        case .profile:
            "PROFILE SETTING"
        case .editProfile:
            "EDIT PROFILE"
        case .topicPhoto:
            "TREND PHOTO"
        case .searchPhoto:
            "SEARCH PHOTO"
        case .likePhoto:
            "MY PHOTOBOX"
        }
    }
    
}

enum ViewType {
    case add
    case edit
}
