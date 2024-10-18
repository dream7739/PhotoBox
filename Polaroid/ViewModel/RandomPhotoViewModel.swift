//
//  RandomPhotoViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 10/18/24.
//

import Foundation

final class RandomPhotoViewModel {
    var inputViewDidLoadTrigger = Observable(())
    var inputLikeButtonClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var outputRandomPhotoResult = Observable<[PhotoResult]>([])
    
    private let repository = RealmRepository()
    
    init(){
        transform()
    }
    
    private func transform() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.callRandomPhoto()
        }
        
        inputLikeButtonClicked.bind { [weak self] value in
            if value {
                self?.savePhotoToRealm()
            }else{
                self?.deletePhotoFromRealm()
            }
        }
        
    }
    
}

extension RandomPhotoViewModel {
    private func callRandomPhoto() {
        NetworkManager.shared.callRequest(
            request: NetworkRequest.randomPhoto,
            response: [PhotoResult].self
        ) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputRandomPhotoResult.value = value
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func savePhotoToRealm(){
        let data = outputRandomPhotoResult.value
        let item = data[inputLikeButtonIndexPath.value]
        repository.addLikePhoto(item)
    }
    
    private func deletePhotoFromRealm() {
        let data = outputRandomPhotoResult.value
        let item = data[inputLikeButtonIndexPath.value]
        repository.deleteLikePhoto(item.id)
    }
    
}
