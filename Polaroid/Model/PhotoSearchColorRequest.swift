//
//  PhotoSearchColorRequest.swift
//  Polaroid
//
//  Created by 홍정민 on 7/28/24.
//

import Foundation

struct PhotoSearchColorRequest {
    let query: String
    let page: Int
    let per_page = Constant.pageCount
    let order_by: String
    let color: String
}
