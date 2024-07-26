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
    
    private let repository = RealmRepository()
  
    init(){
        transform()
    }

}

extension PhotoLikeViewModel {
    private func transform(){
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.outputPhotoLikeResult.value = self?.repository.fetchAll()
        }
    }
    
   
}
