//
//  SearchPhotoViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

final class SearchPhotoViewModel {
    var inputSortCondition = Observable(SearchPhotoViewController.SortCondition.relevant)
    var inputSearchText = Observable("")
    var outputSearchPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    
    var page = 1
    
    init(){
        transform()
    }
    
    private func transform(){
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
    func callSearchPhotoAPI(){
        let photoSearchRequest = PhotoSearchRequest(query: inputSearchText.value, page: page, order_by: inputSortCondition.value.rawValue)
        let request = NetworkRequest.photoSearch(photoSearchRequest)
        
        NetworkManager.shared.callRequest(request: request, response: PhotoSearchResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                if self?.page == 1 {
                    self?.outputSearchPhotoResult.value = value
                }else{
                    self?.outputSearchPhotoResult.value?.results.append(contentsOf: value.results)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
