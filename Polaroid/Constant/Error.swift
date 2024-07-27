//
//  Error.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverIssue
    case error

    
    init(statusCode: Int){
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500...503:
            self = .serverIssue
        default:
              self = .error
        }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증에 문제가 발생했습니다."
        case .forbidden:
            return "거부된 요청입니다."
        case .notFound:
            return "URL을 찾을 수 없습니다."
        case .serverIssue:
            return "서버 상에 문제가 발생했습니다."
        case .error:
            return "에러가 발생했습니다."
        }
    }
}
