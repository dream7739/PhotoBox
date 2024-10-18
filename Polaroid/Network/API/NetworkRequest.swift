//
//  NetworkRequest.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation
import Alamofire

enum NetworkRequest {
    case photoSearch(_ reqest: PhotoSearchRequest)
    case photoSearchColor(_ request: PhotoSearchColorRequest)
    case topicPhoto(_ request: TopicPhotoRequest)
    case photoStatistics(_ request: PhotoStatRequest)
    case randomPhoto

    private enum RequestCondition: String {
        case query
        case page
        case pageCount = "per_page"
        case orderBy = "order_by"
        case color
        case topicID
        case clientId = "client_id"
        case imageID
        case count
    }
    
    var baseURL: String {
        return APIURL.unsplash
    }
    
    var endPoint: String {
        switch self {
        case .photoSearch, .photoSearchColor:
            return baseURL + "/search/photos"
        case .topicPhoto(let request):
            return baseURL + "/topics/\(request.topicID)/photos"
        case .photoStatistics(let request):
            return baseURL + "/photos/\(request.imageID)/statistics"
        case .randomPhoto:
            return baseURL + "/photos/random"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .photoSearch, .photoSearchColor, .topicPhoto, .photoStatistics, .randomPhoto:
            return .get
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
        case .topicPhoto(let request):
            return [
                RequestCondition.page.rawValue: "\(request.page)",
                RequestCondition.clientId.rawValue: APIKey.unsplash
            ]
        case .photoStatistics:
            return [
                RequestCondition.clientId.rawValue: APIKey.unsplash
            ]
        case .photoSearchColor(let request):
            return [
                RequestCondition.query.rawValue: request.query,
                RequestCondition.page.rawValue: "\(request.page)",
                RequestCondition.pageCount.rawValue: "\(request.per_page)",
                RequestCondition.orderBy.rawValue: request.order_by,
                RequestCondition.color.rawValue: request.color,
                RequestCondition.clientId.rawValue: APIKey.unsplash
            ]
        case .randomPhoto:
            return [
                RequestCondition.count.rawValue: "10",
                RequestCondition.clientId.rawValue: APIKey.unsplash
            ]
        }
    }
    
}

