//
//  NicknameViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

final class NicknameViewModel{
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputNickname: Observable<String> = Observable("")
    var outputNicknameText: Observable<String> = Observable("")
    var outputNicknameValid: Observable<Bool> = Observable(false)
    var inputSaveButton: Observable<Void?> = Observable(nil)
    var outputSaveButton: Observable<Void?> = Observable(nil)
    
//    var viewType: ViewType = .add
    var profileImage: String?
    
    private func transform(){
//        inputViewDidLoadTrigger.bind { [weak self] value in
//            if UserManager.profileImage.isEmpty {
//                self?.profileImage = ProfileType.randomTitle
//            }else{
//                self?.profileImage = UserManager.profileImage
//            }
//        }
//        
//        inputNickname.bind { [weak self] value in
//            do {
//                self?.outputNicknameValid.value = try self?.validateUserInput(value) ?? false
//                self?.outputNicknameText.value = "사용 가능한 닉네임입니다 :)"
//            }catch NicknameError.isEmpty {
//                self?.outputNicknameValid.value = false
//                self?.outputNicknameText.value =  NicknameError.isEmpty.description
//            }catch NicknameError.countLimit {
//                self?.outputNicknameValid.value = false
//                self?.outputNicknameText.value =  NicknameError.countLimit.description
//            }catch NicknameError.isNumber{
//                self?.outputNicknameValid.value = false
//                self?.outputNicknameText.value = NicknameError.isNumber.description
//            }catch NicknameError.isSpecialChar {
//                self?.outputNicknameValid.value = false
//                self?.outputNicknameText.value = NicknameError.isSpecialChar.description
//            }catch {
//                print(#function, "error occured")
//            }
//        }
//        
//        inputSaveButton.bind { [weak self] value in
//            if let _ = self?.outputNicknameValid.value {
//                self?.saveUserDefaultsData(self?.viewType ?? .add)
//                self?.outputSaveButton.value = ()
//            }
//        }
    }
    
}

extension NicknameViewModel {
//    @discardableResult
//    private func validateUserInput(_ input: String) throws -> Bool {
//        guard !input.isEmpty else{
//            throw NicknameError.isEmpty
//        }
//        
//        guard input.count >= 2 && input.count <= 10 else {
//            throw NicknameError.countLimit
//        }
//        
//        guard (input.range(of:  #"[@#$%]"#, options: .regularExpression) == nil) else {
//            throw NicknameError.isSpecialChar
//        }
//        
//        guard (input.range(of: #"[0-9]"#, options: .regularExpression) == nil) else {
//            throw NicknameError.isNumber
//        }
//        
//        return true
//    }
    
//    private func saveUserDefaultsData(_ viewType: ViewType){
//        switch viewType {
//        case .add:
//            UserManager.isUser = true
//            UserManager.nickname = inputNickname.value
//            UserManager.joinDate = Date().toString()
//            if let image = profileImage {
//                UserManager.profileImage = image
//            }
//        case .edit:
//            UserManager.nickname = inputNickname.value
//            if let image = profileImage {
//                UserManager.profileImage = image
//            }
//        }
//    }
    
}

