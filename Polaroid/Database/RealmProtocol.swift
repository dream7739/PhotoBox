//
//  RealmProtocol.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol {
    func getRealmFileURL() -> URL?
    func addLikePhoto(_ data: PhotoResult)
    func fetchAllPhoto() -> Results<PhotoInfo>
    func fetchAllPhoto(_ condition: LikeCondition) -> Results<PhotoInfo>
    func deleteLikePhoto(_ photoId: String)
    func isExistLike(id: String) -> Bool
}
