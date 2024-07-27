//
//  SearchPhotoViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation
import RealmSwift

final class SearchPhotoViewModel {
    var inputSortCondition = Observable(SearchCondition.relevant)
    var inputPrefetchTrigger = Observable(())
    var inputSearchText = Observable("")
    var outputSearchPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    var inputLikeButtonClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var outputIsInitalSearch = Observable(true)
    var outputNetworkError = Observable(NetworkError.error)
    
    private var previousSearchWord = ""
    private var searchKeyword = ""
    private var sortCondition = SearchCondition.relevant
    var page = 1
    
    private let repository = RealmRepository()
    
    init(){
        transform()
    }
}

extension SearchPhotoViewModel {
    private func transform(){
        inputSearchText.bind { [weak self] value in
            self?.searchKeyword = value.trimmingCharacters(in: .whitespaces).lowercased()
            
            guard let keyword = self?.searchKeyword else { return }
            
            if !keyword.isEmpty && keyword != self?.previousSearchWord {
                self?.previousSearchWord = keyword
                self?.page = 1
                self?.sortCondition = .relevant
                self?.callSearchPhotoAPI()
            }
        }
        
        inputPrefetchTrigger.bind { [weak self] _ in
            self?.callSearchPhotoAPI()
        }
        
        inputSortCondition.bind { [weak self] value in
            self?.page = 1
            self?.sortCondition = value
            self?.callSearchPhotoAPI()
        }
        
        inputLikeButtonClicked.bind { [weak self] value in
            if value {
                self?.savePhotoToRealm()
            }else{
                self?.deletePhotoFromRealm()
            }
        }
        
    }
    
    func callSearchPhotoAPI() {
        let photoSearchRequest = PhotoSearchRequest(
            query: searchKeyword,
            page: page,
            order_by: sortCondition.rawValue
        )
        
        let request = NetworkRequest.photoSearch(photoSearchRequest)
        
        NetworkManager.shared.callRequest(request: request, response: PhotoSearchResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                if self?.outputIsInitalSearch.value ?? false {
                    self?.outputIsInitalSearch.value.toggle()
                }
                
                if self?.page == 1 {
                    self?.outputSearchPhotoResult.value = value
                }else{
                    self?.outputSearchPhotoResult.value?.results.append(contentsOf: value.results)
                }
            case .failure(let error):
                self?.outputNetworkError.value = error
            }
        }
    }
    
    private func savePhotoToRealm(){
        guard let data = outputSearchPhotoResult.value else { return }
        let item = data.results[inputLikeButtonIndexPath.value]
        repository.addLikePhoto(item)
    }
    
    private func deletePhotoFromRealm(){
        guard let data = outputSearchPhotoResult.value else {
            return
        }
        let item = data.results[inputLikeButtonIndexPath.value]
        repository.deleteLikePhoto(item.id)
    }
}
