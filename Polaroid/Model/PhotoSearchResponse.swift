//
//  PhotoSearchResponse.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

struct PhotoSearchResponse: Decodable {
    let total: Int
    let total_pages: Int
    var results: [PhotoSearchResults]
}

struct PhotoSearchResults: Decodable, Hashable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: ImageLink
    let likes: Int
    let user: User
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
