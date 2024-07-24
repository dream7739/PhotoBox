//
//  NicknameViewModel.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

final class NicknameViewModel{
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var outputProfileImage: Observable<String?> = Observable(nil)
    var inputNickname: Observable<String> = Observable("")
    var outputNicknameText: Observable<String> = Observable("")
    var outputNicknameValid: Observable<Bool> = Observable(false)
    var inputSaveButton: Observable<Void?> = Observable(nil)
    var outputSaveButton: Observable<Void?> = Observable(nil)
    
    var viewType: ViewType = .add
    
    init(){
        transform()
    }
    
    private func transform(){
        inputViewDidLoadTrigger.bind { [weak self] value in
            if UserManager.profileImage.isEmpty {
                self?.outputProfileImage.value = ProfileType.randomTitle
            }else{
                self?.outputProfileImage.value = UserManager.profileImage
            }
            
            
        }
        
        inputNickname.bind { [weak self] value in
            do {
                self?.outputNicknameValid.value = try self?.validateUserInput(value) ?? false
                self?.outputNicknameText.value = "사용 가능한 닉네임입니다 :)"
            }catch NicknameError.isEmpty {
                self?.outputNicknameValid.value = false
                self?.outputNicknameText.value =  NicknameError.isEmpty.localizedDescription
            }catch NicknameError.countLimit {
                self?.outputNicknameValid.value = false
                self?.outputNicknameText.value =  NicknameError.countLimit.localizedDescription
            }catch NicknameError.isNumber{
                self?.outputNicknameValid.value = false
                self?.outputNicknameText.value = NicknameError.isNumber.localizedDescription
            }catch NicknameError.isSpecialChar {
                self?.outputNicknameValid.value = false
                self?.outputNicknameText.value = NicknameError.isSpecialChar.localizedDescription
            }catch {
                print(#function, "error occured")
            }
        }
        
        inputSaveButton.bind { [weak self] value in
            if let _ = self?.outputNicknameValid.value {
                self?.saveUserDefaultsData(self?.viewType ?? .add)
                self?.outputSaveButton.value = ()
            }
        }
    }
    
}

extension NicknameViewModel {
    enum NicknameError: Error, LocalizedError {
        case countLimit
        case isEmpty
        case isSpecialChar
        case isNumber
        
        var errorDescription: String? {
            switch self {
            case .countLimit:
                return "2글자 이상 10글자 미만으로 설정주세요"
            case .isEmpty:
                return "닉네임을 입력해주세요"
            case .isSpecialChar:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .isNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
 
    @discardableResult
    private func validateUserInput(_ input: String) throws -> Bool {
        guard !input.isEmpty else{
            throw NicknameError.isEmpty
        }
        
        guard input.count >= 2 && input.count <= 10 else {
            throw NicknameError.countLimit
        }
        
        guard (input.range(of:  #"[@#$%]"#, options: .regularExpression) == nil) else {
            throw NicknameError.isSpecialChar
        }
        
        guard (input.range(of: #"[0-9]"#, options: .regularExpression) == nil) else {
            throw NicknameError.isNumber
        }
        
        return true
    }
    
    private func saveUserDefaultsData(_ viewType: ViewType){
        switch viewType {
        case .add:
            UserManager.isUser = true
            UserManager.nickname = inputNickname.value
            if let profileImage = outputProfileImage.value {
                UserManager.profileImage = profileImage
            }
        case .edit:
            UserManager.nickname = inputNickname.value
            if let profileImage = outputProfileImage.value {
                UserManager.profileImage = profileImage
            }
        }
    }
    
}

