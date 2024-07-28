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
    var outputNicknameValidText: Observable<String> = Observable("")
    var outputNicknameIsValid: Observable<Bool> = Observable(false)
    var inputMbtiButtonClicked: Observable<Int> = Observable(0)
    var outputMbtiButtonClicked: Observable<[(Int, Bool)]> = Observable([])
    var outputSaveButtonIsEnabled: Observable<Bool> = Observable(false)
    var inputSaveButtonClicked: Observable<Void?> = Observable(nil)
    var outputTransitionTrigger: Observable<Void?> = Observable(nil)
    var inputLeaveButtonClicked: Observable<Void?> = Observable(nil)
    
    private var mbtiClickList = Array.init(repeating: false, count: 8)
    var mbtiWordList = ["E", "I", "S", "N", "T", "F", "J", "P"]
    var viewType: ViewType = .add
    var profileUpdateTrigger: (() -> Void)?
    
    private let repository = RealmRepository()
    
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
            
            if !UserManager.nickname.isEmpty {
                self?.inputNickname.value = UserManager.nickname
            }
        }
        
        inputNickname.bind { [weak self] value in
            do {
                self?.outputNicknameIsValid.value = try self?.validateUserInput(value) ?? false
                self?.outputNicknameValidText.value = "사용 가능한 닉네임입니다 :)"
            }catch NicknameError.countLimit {
                self?.outputNicknameIsValid.value = false
                self?.outputNicknameValidText.value =  NicknameError.countLimit.localizedDescription
            }catch NicknameError.isNumber{
                self?.outputNicknameIsValid.value = false
                self?.outputNicknameValidText.value = NicknameError.isNumber.localizedDescription
            }catch NicknameError.isSpecialChar {
                self?.outputNicknameIsValid.value = false
                self?.outputNicknameValidText.value = NicknameError.isSpecialChar.localizedDescription
            }catch {
                print(#function, "error occured")
            }
            
            self?.examineSaveButtonEnable()
        }
        
        inputMbtiButtonClicked.bind { [weak self] value in
            let compareValue: Int
            
            if value.isMultiple(of: 2) {
                compareValue = value + 1
            }else{
                compareValue = value - 1
            }
            
            let compareClicked = self?.mbtiClickList[compareValue] ?? false
            
            if compareClicked {
                self?.mbtiClickList[compareValue].toggle()
                self?.mbtiClickList[value].toggle()
            }else{
                self?.mbtiClickList[value].toggle()
            }
            
            self?.outputMbtiButtonClicked.value = [
                (value, self?.mbtiClickList[value] ?? false),
                (compareValue, self?.mbtiClickList[compareValue] ?? false)
            ]
                        
            self?.examineSaveButtonEnable()
        }
        
        inputSaveButtonClicked.bind { [weak self] _ in
            ImageFileManager.createImageDirectory()
            self?.saveUserDefaultsData()
            self?.outputTransitionTrigger.value = ()
        }
        
        inputLeaveButtonClicked.bind { [weak self] _ in
            ImageFileManager.deleteImageDirectory()
            UserManager.resetAll()
            self?.repository.deleteAllPhoto()
        }
    }
    
}

extension NicknameViewModel {
    private enum NicknameError: Error, LocalizedError {
        case countLimit
        case isSpecialChar
        case isNumber
        
        var errorDescription: String? {
            switch self {
            case .countLimit:
                return "2글자 이상 10글자 미만으로 설정주세요"
            case .isSpecialChar:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .isNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    @discardableResult
    private func validateUserInput(_ input: String) throws -> Bool {
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
    
    private func examineSaveButtonEnable(){
        let mbtiCount = mbtiClickList.filter{ $0 }.count
        
        if outputNicknameIsValid.value && mbtiCount == 4{
            outputSaveButtonIsEnabled.value = true
        }else{
            outputSaveButtonIsEnabled.value = false
        }
    }
    
    private func saveUserDefaultsData(){
        UserManager.isUser = true
        UserManager.nickname = inputNickname.value
        if let profileImage = outputProfileImage.value {
            UserManager.profileImage = profileImage
        }
        UserManager.mbti = createMbtiArray()
    }
    
    private func createMbtiArray() -> [Int] {
        var mbtiArray: [Int] = []
        
        for idx in 0..<mbtiClickList.count{
            if mbtiClickList[idx] {
                mbtiArray.append(idx)
            }
        }
        
        return mbtiArray
    }
    
}

