//
//  NicknameViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit

import UIKit
import SnapKit

final class NicknameViewController: BaseViewController {
    private let profileView = RoundProfileView()
    private let nicknameField = UnderLineTextField()
    private let validLabel = UILabel()
    private let mbtiLabel = UILabel()
    private let firstMbtiStackView = UIStackView()
    private let secondMbtiStackView = UIStackView()
    private let eButton = RoundToggleButton()
    private let iButton = RoundToggleButton()
    private let sButton = RoundToggleButton()
    private let nButton = RoundToggleButton()
    private let tButton = RoundToggleButton()
    private let fButton = RoundToggleButton()
    private let jButton = RoundToggleButton()
    private let pButton = RoundToggleButton()
    private let completeButton = RoundButton()
    private let leaveButton = UIButton(type: .system)
    
    private lazy var mbtiButtonList = [eButton, iButton, sButton, nButton, tButton, fButton, jButton, pButton]
    
    let viewModel = NicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureAction()
        configureViewType()
    }
    
    override func configureHierarchy() {
        view.addSubview(profileView)
        view.addSubview(nicknameField)
        view.addSubview(validLabel)
        view.addSubview(mbtiLabel)
        view.addSubview(firstMbtiStackView)
        view.addSubview(secondMbtiStackView)
        view.addSubview(completeButton)
        view.addSubview(leaveButton)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(140)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(nicknameField)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(40)
            make.leading.equalTo(validLabel)
        }
        
        firstMbtiStackView.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(70)
        }
        
        secondMbtiStackView.snp.makeConstraints { make in
            make.top.equalTo(firstMbtiStackView.snp.bottom).offset(6)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(70)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        leaveButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI() {
        nicknameField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameField.clearButtonMode = .whileEditing
        validLabel.font = Design.FontType.tertiary
        mbtiLabel.text = "MBTI"
        mbtiLabel.font = .boldSystemFont(ofSize: 15)
        
        firstMbtiStackView.axis = .horizontal
        firstMbtiStackView.spacing = 10
        firstMbtiStackView.distribution = .fillEqually
        firstMbtiStackView.addArrangedSubview(eButton)
        firstMbtiStackView.addArrangedSubview(sButton)
        firstMbtiStackView.addArrangedSubview(tButton)
        firstMbtiStackView.addArrangedSubview(jButton)
        
        secondMbtiStackView.axis = .horizontal
        secondMbtiStackView.spacing = 10
        secondMbtiStackView.distribution = .fillEqually
        secondMbtiStackView.addArrangedSubview(iButton)
        secondMbtiStackView.addArrangedSubview(nButton)
        secondMbtiStackView.addArrangedSubview(fButton)
        secondMbtiStackView.addArrangedSubview(pButton)
        
        for idx in 0..<viewModel.mbtiWordList.count{
            mbtiButtonList[idx].configuration?.title = viewModel.mbtiWordList[idx]
        }
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.isEnabled = false
        completeButton.backgroundColor = .dark_gray
        
    }
    
    private func configureAction(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nicknameField.addTarget(self, action: #selector(completeButtonClicked), for: .editingDidEndOnExit)
        
        for idx in 0..<mbtiButtonList.count {
            mbtiButtonList[idx].tag = idx
            mbtiButtonList[idx].addTarget(self, action: #selector(mbtiButtonClicked), for: .touchUpInside)
        }
        
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        leaveButton.addTarget(self, action: #selector(leaveButtonClicked), for: .touchUpInside)
    }
}

extension NicknameViewController {
    private func configureViewType(){
        switch viewModel.viewType {
        case .add:
            navigationItem.title = Navigation.profile.title
            nicknameField.text = ""
            leaveButton.isHidden = true
        case .edit:
            navigationItem.title = Navigation.editProfile.title
            nicknameField.text = UserManager.nickname
            configureSaveBarButtonItem()
            completeButton.isHidden = true
            configureMbtiButton()
            configureLeaveButton()
        }
    }
    
    private func configureSaveBarButtonItem(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        save.isEnabled = false
        save.tintColor = .dark_gray
        navigationItem.rightBarButtonItem = save
    }
    
    private func configureLeaveButton(){
        leaveButton.setTitle("회원탈퇴", for: .normal)
        leaveButton.setUnderLine()
    }
    
    private func configureMbtiButton(){
        UserManager.mbti.forEach { value in
            mbtiButtonClicked(sender: mbtiButtonList[value])
        }
    }
    
    private func bindData(){
        viewModel.outputProfileImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.profileView.profileImage.image = UIImage(named: value)
        }
        
        viewModel.outputNicknameValidText.bind { [weak self] value in
            self?.validLabel.text = value
        }
        
        viewModel.outputNicknameIsValid.bind { [weak self] value in
            if value {
                self?.nicknameField.setLineColor(type: .valid)
                self?.validLabel.textColor = .black
            }else{
                self?.nicknameField.setLineColor(type: .inValid)
                self?.validLabel.textColor = .theme_blue
            }
        }
        
        viewModel.outputSaveButtonIsEnabled.bind { [weak self] value in
            if value {
                self?.completeButton.isEnabled = true
                self?.completeButton.backgroundColor = .theme_blue
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.navigationItem.rightBarButtonItem?.tintColor = .black
            }else{
                self?.completeButton.isEnabled = false
                self?.completeButton.backgroundColor = .dark_gray
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                self?.navigationItem.rightBarButtonItem?.tintColor = .dark_gray
            }
        }
        
        viewModel.outputTransitionTrigger.bind { [weak self] value in
            if let type = self?.viewModel.viewType {
                switch type {
                case .add:
                    self?.transitionScene(PolaroidTabBarController())
                case .edit:
                    self?.viewModel.profileUpdateTrigger?()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        viewModel.outputMbtiButtonClicked.bind { [weak self] value in
            if let selectValue = value.first {
                self?.mbtiButtonList[selectValue.0].isClicked = selectValue.1
            }
            
            if let compareValue = value.last {
                self?.mbtiButtonList[compareValue.0].isClicked = compareValue.1
            }
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
        
    }
    
    @objc private func profileImageClicked(){
        let profileVC = ProfileViewController()
        profileVC.profileImageSender = { [weak self] profile in
            self?.viewModel.outputProfileImage.value = profile
            self?.profileView.profileImage.image = UIImage(named: profile ?? "")
        }
        profileVC.viewType = viewModel.viewType
        profileVC.profileImage = viewModel.outputProfileImage.value
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func textFieldChanged(){
        let inputText = nicknameField.text!.trimmingCharacters(in: .whitespaces)
        viewModel.inputNickname.value = inputText
    }
    
    @objc private func completeButtonClicked(){
        viewModel.inputSaveButtonClicked.value = ()
    }
    
    @objc private func mbtiButtonClicked(sender: RoundToggleButton){
        viewModel.inputMbtiButtonClicked.value = sender.tag
    }
    
    @objc func leaveButtonClicked(){
        showAlert("알림", "탈퇴하시면 모든 정보가 삭제됩니다") { [weak self] _ in
            self?.viewModel.inputLeaveButtonClicked.value = ()
            self?.transitionScene(UINavigationController(rootViewController: OnboardingViewController()))
        }
    }
}

