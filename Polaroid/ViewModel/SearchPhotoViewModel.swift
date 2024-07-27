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
    var inputSearchPageCount = Observable(1)
    var inputSearchText = Observable("")
    var outputSearchPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    var inputLikeButtonClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    var outputIsInitalSearch = Observable(true)
    var outputErrorOccured = Observable(())
    
    private let repository = RealmRepository()
    
    init(){
        print(repository.getRealmURL())
        transform()
    }
}

extension SearchPhotoViewModel {
    private func transform(){
        inputSearchText.bind { [weak self] value in
            let text = value.trimmingCharacters(in: .whitespaces)
            
            if !text.isEmpty {                
                if self?.outputIsInitalSearch.value ?? false {
                    self?.outputIsInitalSearch.value.toggle()
                }
            }
        }
        
        inputSearchPageCount.bind { [weak self] _ in
            self?.callSearchPhotoAPI()
        }
        
        inputSortCondition.bind { [weak self] value in
            self?.inputSearchPageCount.value = 1
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
            query: inputSearchText.value,
            page: inputSearchPageCount.value,
            order_by: inputSortCondition.value.rawValue
        )
        
        let request = NetworkRequest.photoSearch(photoSearchRequest)
        
        NetworkManager.shared.callRequest(request: request, response: PhotoSearchResponse.self) { [weak self] response in
            switch response {
            case .success(let value):
                if self?.inputSearchPageCount.value == 1 {
                    self?.outputSearchPhotoResult.value = value
                }else{
                    self?.outputSearchPhotoResult.value?.results.append(contentsOf: value.results)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.outputErrorOccured.value = ()
            }
        }
    }
    
    private func savePhotoToRealm(){
        guard let data = outputSearchPhotoResult.value else { return }
        let item = data.results[inputLikeButtonIndexPath.value]
        repository.addLike(item)
    }
    
    private func deletePhotoFromRealm(){
        guard let data = outputSearchPhotoResult.value else {
            return
        }
        let item = data.results[inputLikeButtonIndexPath.value]
        repository.deleteLike(item.id)
    }
}
