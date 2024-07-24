//
//  SearchPhotoViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

final class SearchPhotoViewModel {
//    var inputViewDidLoadTrigger = Observable(())
    var inputSortCondition = Observable(SearchPhotoViewController.SortCondition.relevant)
    var inputSearchText = Observable("")
    var outputSearchPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    
    init(){
        transform()
    }
    
    private func transform(){
//        inputViewDidLoadTrigger.bind { [weak self] _ in
//            self?.callSearchPhotoAPI()
//        }
        
        inputSortCondition.bind { [weak self] _ in
            self?.callSearchPhotoAPI()
        }
        
        inputSearchText.bind { [weak self] value in
            let text = value.trimmingCharacters(in: .whitespaces)
            if !text.isEmpty {
                self?.callSearchPhotoAPI()
            }
        }
    }
}

extension SearchPhotoViewModel {
    private func callSearchPhotoAPI(){
        let photoSearchRequest = PhotoSearchRequest(query: inputSearchText.value, page: 1, order_by: inputSortCondition.value.rawValue)
        let request = NetworkRequest.photoSearch(photoSearchRequest)
        
        NetworkManager.shared.callRequest(request: request, response: PhotoSearchResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputSearchPhotoResult.value = value
            case .failure(let error):
                print(error)
            }
        }
    }
}
