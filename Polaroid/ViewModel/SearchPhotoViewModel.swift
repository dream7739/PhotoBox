//
//  SearchPhotoViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation
import RealmSwift

final class SearchPhotoViewModel {
    var inputSortButtonClicked = Observable(SearchCondition.relevant)
    var inputPrefetchTrigger = Observable(())
    var inputSearchText = Observable("")
    var outputSearchPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    var outputSearchFilterPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    var inputLikeButtonClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var outputInitialSearch = Observable(true)
    var outputNetworkError = Observable(NetworkError.error)
    var inputColorOptionButtonClicked = Observable((idx: 0, isClicked: false))
    var outputScrollTopTrigger = Observable(())
    var outputInitColorOptionTrigger = Observable(())
    
    private var previousSearchWord = ""
    private var previousSortCondition = SearchCondition.relevant
    private var searchKeyword = ""
    private var sortCondition = SearchCondition.relevant
    var isColorOptionClicked = false
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
            let isValidInput = self?.validateSearchText(self?.searchKeyword ?? "") ?? false
            
            if isValidInput {
                self?.makeSearchTextStatus()
                self?.callRequestBySearchText()
            }else{
                return
            }
        }
        
        inputPrefetchTrigger.bind { [weak self] _ in
            if self?.isColorOptionClicked ?? false {
                guard let idx = self?.inputColorOptionButtonClicked.value.idx else { return }
                self?.callSearchPhotoColorAPI(ColorCondition.allCases[idx].rawValue)
            }else{
                self?.callSearchPhotoAPI()
            }
        }
        
        inputColorOptionButtonClicked.bind { [weak self] value in
            guard let data = self?.outputSearchPhotoResult.value, data.results.count > 0 else { return }
                        
            self?.isColorOptionClicked = value.isClicked
            self?.callRequestByColorOption(value.idx)
        
        }
        
        inputSortButtonClicked.bind { [weak self] value in
            guard let data = self?.outputSearchFilterPhotoResult.value, data.results.count > 0 else { return }
            guard let colorOption = self?.inputColorOptionButtonClicked.value else { return }
            
            self?.sortCondition = value
            
            self?.callRequestBySortOption(colorOption.idx)
   
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

extension SearchPhotoViewModel {
    private func callSearchPhotoAPI() {

        let photoSearchRequest = PhotoSearchRequest(
            query: searchKeyword,
            page: page,
            order_by: sortCondition.rawValue
        )
        
        previousSortCondition = sortCondition
        
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
        
        if isColorOptionClicked {
            let color = ColorCondition.allCases[inputColorOptionButtonClicked.value.idx].rawValue
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


extension SearchPhotoViewModel {
    private func validateSearchText(_ searchText: String) -> Bool{
        if searchText.isEmpty || searchText == previousSearchWord {
            return false
        }else{
            return true
        }
    }
    
    private func makeSearchTextStatus(){
        if outputInitialSearch.value {
            outputInitialSearch.value.toggle()
        }
        
        if inputColorOptionButtonClicked.value.isClicked {
            outputInitColorOptionTrigger.value = ()
        }
    }
    
    private func callRequestBySearchText(){
        previousSearchWord = searchKeyword
        isColorOptionClicked = false
        page = 1
        sortCondition = .relevant
        callSearchPhotoAPI()
    }
    
    private func callRequestByColorOption(_ idx: Int){
        if isColorOptionClicked {
            let color = ColorCondition.allCases[idx].rawValue
            filterPage = 1
            callSearchPhotoColorAPI(color)
        }else if previousSortCondition == sortCondition {
            outputSearchFilterPhotoResult.value = outputSearchPhotoResult.value
            outputScrollTopTrigger.value = ()
        }else if previousSortCondition != sortCondition {
            page = 1
            callSearchPhotoAPI()
        }
    }
    
    private func callRequestBySortOption(_ idx: Int){
        if isColorOptionClicked {
            filterPage = 1
            callSearchPhotoColorAPI(ColorCondition.allCases[idx].rawValue)
        }else{
            page = 1
            callSearchPhotoAPI()
        }
    }
}
