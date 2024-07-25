//
//  TopicPhotoViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import Foundation

final class TopicPhotoViewModel {
    var inputViewDidLoadTrigger = Observable(())
    var outputGoldenHourReulst: [PhotoResult] = []
    var outputBusinessWorkReulst: [PhotoResult] = []
    var outputArchitectureInteriorReulst:[PhotoResult] = []
    var outputUpdateSnapshotTrigger = Observable(())
    
    init(){
        transform()
    }

}

extension TopicPhotoViewModel {
    private func transform(){
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.callTopicPhotoAPI()
        }
    }
    
    private func callTopicPhotoAPI(){
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.callRequest(request: NetworkRequest.topicPhoto(TopicPhotoRequest(topicID: Section.goldenHour.topicID)), response: [PhotoResult].self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputGoldenHourReulst = value
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.callRequest(request: NetworkRequest.topicPhoto(TopicPhotoRequest(topicID: Section.businessWork.topicID)), response: [PhotoResult].self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputBusinessWorkReulst = value
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.callRequest(request: NetworkRequest.topicPhoto(TopicPhotoRequest(topicID: Section.architectureInterior.topicID)), response: [PhotoResult].self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.outputArchitectureInteriorReulst = value
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.outputUpdateSnapshotTrigger.value = ()
        }
    }
    
    
}
