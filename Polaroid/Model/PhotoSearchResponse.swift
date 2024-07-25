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
    var results: [PhotoResult]
}
