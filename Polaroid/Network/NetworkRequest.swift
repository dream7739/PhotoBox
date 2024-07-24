//
//  NetworkRequest.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

enum NetworkRequest {
    case photoSearch(_ reqest: PhotoSearchRequest)
    
    var baseURL: String {
        return APIURL.unsplash
    }
    
    var endPoint: String {
        switch self {
        case .photoSearch:
            return baseURL + "/search/photos"
        }
    }
    
    var method: String {
        switch self {
        case .photoSearch:
            return "GET"
        }
    }
    
    var param: [String: String] {
        switch self {
        case .photoSearch(let request):
            return [
                RequestCondition.query.rawValue: request.query,
                RequestCondition.page.rawValue: "\(request.page)",
                RequestCondition.pageCount.rawValue: "\(request.per_page)",
                RequestCondition.orderBy.rawValue: request.order_by,
                RequestCondition.clientId.rawValue: APIKey.unsplash
            ]
        }
    }
    
}

enum RequestCondition: String {
    case query
    case page
    case pageCount = "per_page"
    case orderBy = "order_by"
    case color
    case clientId = "client_id"
}
