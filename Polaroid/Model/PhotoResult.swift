//
//  PhotoResult.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import Foundation

struct PhotoResult: Decodable, Hashable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: ImageLink
    let likes: Int
    let user: User
    
    var sizeDescription: String {
        return "\(width) x \(height)"
    }
    
    var dateDescription: String {
        return created_at.convertCreateDate() + " 게시됨"
    }
}

struct ImageLink: Decodable, Hashable {
    let raw: String
    let small: String
}

struct User: Decodable, Hashable {
    let name: String
    let profile_image: ProfileImage
}

struct ProfileImage: Decodable, Hashable {
    let medium: String
}
