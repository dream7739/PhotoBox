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
    var outputSearchFilterPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    var inputLikeButtonClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var outputIsInitalSearch = Observable(true)
    var outputNetworkError = Observable(NetworkError.error)
    var inputOptionButtonClicked = Observable((0, false))
    var outputScrollTopTrigger = Observable(())
    var outputFilterOptionInitTrigger = Observable(())
    
    private var previousSearchWord = ""
    private var searchKeyword = ""
    private var sortCondition = SearchCondition.relevant
    
    var page = 1
    var filterPage = 1
    
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
                
                if self?.outputIsInitalSearch.value ?? false {
                    self?.outputIsInitalSearch.value.toggle()
                }
                
                if self?.inputOptionButtonClicked.value.1 ?? false {
                    self?.outputFilterOptionInitTrigger.value = ()
                }
                
                self?.previousSearchWord = keyword
                self?.page = 1
                self?.sortCondition = .relevant
                self?.callSearchPhotoAPI()
            }
        }
        
        inputPrefetchTrigger.bind { [weak self] _ in
            guard let value = self?.inputOptionButtonClicked.value else { return }
            
            if value.1 {
                self?.callSearchPhotoColorAPI(ColorCondition.allCases[value.0].rawValue)
            }else{
                self?.callSearchPhotoAPI()
            }
        }
        
        inputOptionButtonClicked.bind { [weak self] value in
            guard let data = self?.outputSearchPhotoResult.value, data.results.count > 0 else {
                return
            }
            
            let isClicked = value.1
            
            if isClicked {
                let color = ColorCondition.allCases[value.0].rawValue
                self?.filterPage = 1
                self?.callSearchPhotoColorAPI(color)
            }else{
                self?.outputSearchFilterPhotoResult.value = self?.outputSearchPhotoResult.value
                self?.outputScrollTopTrigger.value = ()
            }
        }
        
        inputSortCondition.bind { [weak self] value in
            guard let data = self?.outputSearchPhotoResult.value, data.results.count > 0 else {
                return
            }
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
    
    private func callSearchPhotoAPI() {
        let photoSearchRequest = PhotoSearchRequest(
            query: searchKeyword,
            page: page,
            order_by: sortCondition.rawValue
        )
        
        let request = NetworkRequest.photoSearch(photoSearchRequest)
        
        NetworkManager.shared.callRequest(request: request, response: PhotoSearchResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                if self?.page == 1 {
                    self?.outputSearchPhotoResult.value = value
                    self?.outputSearchFilterPhotoResult.value = value
                    self?.outputScrollTopTrigger.value = ()
                }else{
                    self?.outputSearchPhotoResult.value?.results.append(contentsOf: value.results)
                    self?.outputSearchFilterPhotoResult.value?.results.append(contentsOf: value.results)
                }
            case .failure(let error):
                self?.outputNetworkError.value = error
            }
        }
    }
    
    private func callSearchPhotoColorAPI(_ color: String){

        let photoSearchColorRequest = PhotoSearchColorRequest(
            query: searchKeyword,
            page: filterPage,
            order_by: sortCondition.rawValue,
            color: color
        )
        
        let request = NetworkRequest.photoSearchColor(photoSearchColorRequest)
        
        NetworkManager.shared.callRequest(request: request, response: PhotoSearchResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                if self?.filterPage == 1 {
                    self?.outputSearchFilterPhotoResult.value = value
                    self?.outputScrollTopTrigger.value = ()
                }else{
                    self?.outputSearchFilterPhotoResult.value?.results.append(contentsOf: value.results)
                }
            case .failure(let error):
                self?.outputNetworkError.value = error
            }
        }
    }
    
    private func savePhotoToRealm(){
        guard let data = outputSearchFilterPhotoResult.value else { return }
        let item = data.results[inputLikeButtonIndexPath.value]
        
        if inputOptionButtonClicked.value.1 {
            let color = ColorCondition.allCases[inputOptionButtonClicked.value.0].rawValue
            repository.addLikePhoto(item, color)
        }else{
            repository.addLikePhoto(item)
        }
    }
    
    private func deletePhotoFromRealm(){
        guard let data = outputSearchFilterPhotoResult.value else { return }
        let item = data.results[inputLikeButtonIndexPath.value]
        repository.deleteLikePhoto(item.id)
    }
}
