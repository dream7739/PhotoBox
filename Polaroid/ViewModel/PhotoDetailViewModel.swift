//
//  PhotoDetailViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import Foundation

final class PhotoDetailViewModel {
    var inputPhotoResult: Observable<PhotoResult?> = Observable(nil)
    var outputPhotoStatResult: Observable<PhotoStatResponse?> = Observable(nil)
  
    init(){
        transform()
    }

}

extension PhotoDetailViewModel {
    private func transform(){
        inputPhotoResult.bind { [weak self] value in
            guard let value = value else { return }
            self?.callPhotoStatisticsAPI(value.id)
        }
    }
    
    private func callPhotoStatisticsAPI(_ imageID: String){
        NetworkManager.shared.callRequest(request: NetworkRequest.photoStatistics(PhotoStatRequest(imageID: imageID)), response: PhotoStatResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputPhotoStatResult.value = value
            case .failure(let error):
                print(error)
            }
        }
    }
}
