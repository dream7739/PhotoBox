//
//  RealmLikeModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import Foundation
import RealmSwift

class PhotoInfo: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var created_at: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var likes: Int
    @Persisted var urls: List<ImageInfo>
    @Persisted var user: List<UserInfo>
    @Persisted var regDate: Date
    
    convenience init(id: String, created_at: String, width: Int, height: Int, likes: Int) {
        self.init()
        self.id = id
        self.created_at = created_at
        self.width = width
        self.height = height
        self.likes = likes
        self.regDate = Date()
    }

}

extension PhotoInfo {
    func convertPhotoResult() -> PhotoResult {
        let photoResult = PhotoResult(
            id: id,
            created_at: created_at,
            width: width,
            height: height,
            urls: ImageLink(
                raw: urls.first?.raw ?? "",
                small: urls.first?.small ?? ""
            ),
            likes: likes,
            user: User(
                name: user.first?.name ?? "",
                profile_image: ProfileImage(
                    medium: user.first?.profile_image ?? ""
                )
            )
        )
        return photoResult
    }
}

class ImageInfo: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var raw: String
    @Persisted var small: String
    @Persisted var regDate: Date
    
    @Persisted(originProperty: "urls")
    var photo: LinkingObjects<PhotoInfo>
    
    convenience init(raw: String, small: String) {
        self.init()
        self.raw = raw
        self.small = small
        self.regDate = Date()
    }
}

class UserInfo: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var name: String
    @Persisted var profile_image: String
    @Persisted var regDate: Date
    
    @Persisted(originProperty: "user")
    var photo: LinkingObjects<PhotoInfo>
    
    convenience init(name: String, profile_image: String) {
        self.init()
        self.name = name
        self.profile_image = profile_image
        self.regDate = Date()
    }
    
}
