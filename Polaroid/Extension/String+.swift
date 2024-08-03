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
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                completion(.success(image))
            }
        }else{
            DispatchQueue.main.async {
                completion(.failure(LoadImageError.failedDownload))
            }
            
        }
    }
    
    func convertCreateDate() -> String {
        let convertDate = DateFormatterManager.basicDateFormatter.date(from: self) ?? Date()
        let dateString = DateFormatterManager.basicDateFormatter.string(from: convertDate)
        return dateString
    }
}
