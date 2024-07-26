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
    var inputSearchText = Observable("")
    var outputSearchPhotoResult: Observable<PhotoSearchResponse?> = Observable(nil)
    var inputLikeButtonClicked = Observable(false)
    var inputLikeButtonIndexPath = Observable(0)
    
    private let repository = RealmRepository()
    var page = 1
    
    init(){
        print(repository.getRealmURL())
        
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
