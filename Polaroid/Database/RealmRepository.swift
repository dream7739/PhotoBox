//
//  RealmRepository.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func getRealmURL() -> URL? {
        return realm.configuration.fileURL
    }
    
    func addLike(_ data: PhotoResult)  {
        let item = PhotoInfo(
            id: data.id,
            created_at: data.created_at,
            width: data.width,
            height: data.height,
            likes: data.likes
        )
        
        item.urls.append(ImageInfo(raw: data.urls.raw, small: data.urls.small))
        item.user.append(UserInfo(name: data.user.name, profile_image: data.user.profile_image.medium))
        
        do{
            try realm.write {
                realm.add(item)
            }
        }catch {
            print("addLike Failed")
        }
    }
    
    func fetchAll() -> Results<PhotoInfo> {
        return realm.objects(PhotoInfo.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    
    func fetchAll(_ condition: LikeCondition) -> Results<PhotoInfo>{
        switch condition {
        case .latest:
            return realm.objects(PhotoInfo.self).sorted(byKeyPath: "regDate", ascending: false)
        case .earliest:
            return realm.objects(PhotoInfo.self).sorted(byKeyPath: "regDate", ascending: true)
        }
    }
    
    func deleteLike(_ photoId: String) {
        if let item = realm.object(ofType: PhotoInfo.self, forPrimaryKey: photoId){
            do{
                try realm.write {
                    realm.delete(item.urls)
                    realm.delete(item.user)
                    realm.delete(item)
                }
            }catch{
                print("deleteLike Failed")
            }
        }
    }
    
    func deleteLike(_ item: PhotoInfo) {
        do{
            try realm.write {
                realm.delete(item.urls)
                realm.delete(item.user)
                realm.delete(item)
            }
        }catch{
            print("deleteLike Failed")
        }
    }
    
    func isExistLike(id: String) -> Bool{
        if let _ = realm.object(ofType: PhotoInfo.self, forPrimaryKey: id){
            return true
        }else{
            return false
        }
    }
}
