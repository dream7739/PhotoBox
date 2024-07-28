//
//  PhotoDetailViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import Foundation
import RealmSwift

final class PhotoDetailViewModel {
    var inputViewDidLoadTrigger = Observable(())
    var inputViewWillAppearTrigger = Observable(())
    var outputPhotoStatResult: Observable<PhotoStatResponse?> = Observable(nil)
    var outputPhotoIsLiked = Observable(false)
    var inputHeartButtonClicked = Observable(false)
    var outputNetworkError = Observable(NetworkError.error)
  
    var inputPhotoResult: PhotoResult? = nil
    var viewType: DetailViewType = .search

    private let repository = RealmRepository()
    
    init(){
        transform()
    }

}

extension PhotoDetailViewModel {
    enum DetailViewType {
        case search
        case like
    }
    
    private func transform(){
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let input = self?.inputPhotoResult else { return }
            self?.callPhotoStatisticsAPI(input.id)
            self?.confirmPhotoIsLiked(input.id)
        }
        
        inputViewWillAppearTrigger.bind { [weak self] _ in
            guard let input = self?.inputPhotoResult else { return }
            self?.confirmPhotoIsLiked(input.id)
        }
        
        inputHeartButtonClicked.bind { [weak self] value in
            guard let input = self?.inputPhotoResult else { return }

            if value {
                self?.repository.addLikePhoto(input)
            }else{
                self?.repository.deleteLikePhoto(input.id)
            }
        }
        
    }
    
    private func callPhotoStatisticsAPI(_ imageID: String){
        NetworkManager.shared.callRequest(request: NetworkRequest.photoStatistics(PhotoStatRequest(imageID: imageID)), response: PhotoStatResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputPhotoStatResult.value = value
            case .failure(let error):
                self?.outputNetworkError.value = error
            }
        }
    }
    
    private func confirmPhotoIsLiked(_ imageID: String){
        outputPhotoIsLiked.value = repository.isExistLike(id: imageID)
    }
}
