//
//  PhotoLikeViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import Foundation
import RealmSwift

final class PhotoLikeViewModel {
    var inputViewDidLoadTrigger = Observable(())
    var outputPhotoLikeResult: Observable<Results<PhotoInfo>?> = Observable(nil)
    var inputLikeButtonIsClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var inputSortButtonClicked = Observable(LikeCondition.latest)
    
    private let repository = RealmRepository()
    
    init(){
        transform()
    }
    
}

extension PhotoLikeViewModel {
    private func transform(){
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.outputPhotoLikeResult.value = self?.repository.fetchAllPhoto()
        }
        
        inputLikeButtonIsClicked.bind { [weak self] value in
            guard let data = self?.outputPhotoLikeResult.value, let index = self?.inputLikeButtonIndexPath.value else { return }
            self?.repository.deleteLikePhoto(data[index].id)
            self?.outputPhotoLikeResult.value = self?.repository.fetchAllPhoto()
        }
        
        inputSortButtonClicked.bind { [weak self] value in
            self?.outputPhotoLikeResult.value = self?.repository.fetchAllPhoto(value)
        }
    }
    
    
}
