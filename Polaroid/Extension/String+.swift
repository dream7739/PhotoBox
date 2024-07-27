//
//  String+.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import UIKit

extension String {
    func loadImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: self) else {
            completion(.failure(LoadImageError.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(.failure(LoadImageError.failedDownload))
                }
            }
            
        }
    }
}

enum LoadImageError: Error, LocalizedError {
    case invalidURL
    case failedDownload
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 이미지 URL입니다."
        case .failedDownload:
            return "이미지를 다운받는데 실패하였습니다."
        }
    }
}
