//
//  UserDefaultsManager.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

@propertyWrapper
struct UserDefaultsManager<T> {
    var defaultValue: T
    var key: String
    var storage: UserDefaults

    var wrappedValue: T {
        get {
            return self.storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            self.storage.set(newValue, forKey: key)
        }
    }
}

final class UserManager {
    private init(){}
    
    @UserDefaultsManager(
        defaultValue: false,
        key: "isUser",
        storage: .standard
    )
    static var isUser: Bool
    
    
    @UserDefaultsManager(
        defaultValue: "",
        key: "profile",
        storage: .standard
    )
    static var profileImage: String
    
    @UserDefaultsManager(
        defaultValue: "",
        key: "nickname",
        storage: .standard
    )
    static var nickname: String
    
    @UserDefaultsManager(
        defaultValue: "",
        key: "mbti",
        storage: .standard
    )
    static var mbti: String
        
    static func resetAll(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
