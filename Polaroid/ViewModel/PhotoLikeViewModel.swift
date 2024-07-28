//
//  PhotoLikeViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import Foundation
import RealmSwift

final class PhotoLikeViewModel {
    var inputViewWillAppearTrigger = Observable(())
    var outputPhotoLikeResult: Observable<Results<PhotoInfo>?> = Observable(nil)
    var inputLikeButtonIsClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var inputSortButtonClicked = Observable(LikeCondition.latest)
    var outputScrollToTopTrigger = Observable(())
    var inputOptionButtonClicked = Observable(0)

    private var optionList = Array.init(repeating: false, count: ColorCondition.allCases.count)
    
    private let repository = RealmRepository()
    
    
    init(){
        transform()
    }
    
}

extension PhotoLikeViewModel {
    private func transform(){
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchPhotosFromRealm()
        }
        
        inputOptionButtonClicked.bind { [weak self] value in
            self?.optionList[value].toggle()
            self?.fetchPhotosFromRealm()
            self?.outputScrollToTopTrigger.value = ()
        }
        
        inputLikeButtonIsClicked.bind { [weak self] value in
            guard let data = self?.outputPhotoLikeResult.value, let index = self?.inputLikeButtonIndexPath.value else { return }
            
            self?.repository.deleteLikePhoto(data[index].id)
            self?.fetchPhotosFromRealm()
        }
        
        inputSortButtonClicked.bind { [weak self] value in
            self?.fetchPhotosFromRealm()
            self?.outputScrollToTopTrigger.value = ()
        }
    }
    
    private func createColorOption() -> [String] {
        var options: [String] = []
        
        for idx in 0..<optionList.count {
            if optionList[idx] {
                options.append(ColorCondition.allCases[idx].rawValue)
            }
        }
        
        return options
    }
    
    private func fetchPhotosFromRealm(){
        let options = createColorOption()
        let condition = inputSortButtonClicked.value
        
        if options.isEmpty {
            outputPhotoLikeResult.value = repository.fetchAllPhoto(condition)
        }else{
            outputPhotoLikeResult.value = repository.fetchFilteredPhoto(options: options, conditon: condition)
        }
    }
}
