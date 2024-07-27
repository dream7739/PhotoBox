//
//  NetworkManager.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation
import Alamofire


final class NetworkManager {
    static let shared = NetworkManager()
    private init(){ }
    
    func callRequest<T: Decodable>(request: NetworkRequest, response: T.Type, completion: @escaping (Result<T, Error>) -> Void){
        AF.request(request.endPoint,
                   parameters: request.param,
                   encoding: URLEncoding.queryString)
        .validate(statusCode: 200...500)
        .responseDecodable(of: T.self) { response in
            guard let statusCode = response.response?.statusCode else { return}
            switch statusCode {
            case 200:
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(NetworkError(statusCode: statusCode)))
                }
            default:
                completion(.failure(NetworkError(statusCode: statusCode)))
            }
        }
    }
    
}
