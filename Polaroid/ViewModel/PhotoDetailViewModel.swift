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
    var outputErrorOccured = Observable(())
  
    var inputPhotoResult: PhotoResult? = nil
    
    private let repository = RealmRepository()
    
    init(){
        transform()
    }

}

extension PhotoDetailViewModel {
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
                self?.repository.addLike(input)
            }else{
                self?.repository.deleteLike(input.id)
            }
        }
        
    }
    
    private func callPhotoStatisticsAPI(_ imageID: String){
        NetworkManager.shared.callRequest(request: NetworkRequest.photoStatistics(PhotoStatRequest(imageID: imageID)), response: PhotoStatResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputPhotoStatResult.value = value
            case .failure(let error):
                print(error.localizedDescription)
                self?.outputErrorOccured.value = ()
            }
        }
    }
    
    private func confirmPhotoIsLiked(_ imageID: String){
        outputPhotoIsLiked.value = repository.isExistLike(id: imageID)
    }
}
