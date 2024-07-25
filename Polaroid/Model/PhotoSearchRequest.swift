//
//  PhotoSearchRequest.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

struct PhotoSearchRequest {
    let query: String
    let page: Int
    let per_page = 20
    let order_by: String
}
