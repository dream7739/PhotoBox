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
    private let eButton = RoundToggleButton(title: "E")
    private let iButton = RoundToggleButton(title: "I")
    private let sButton = RoundToggleButton(title: "S")
    private let nButton = RoundToggleButton(title: "N")
    private let tButton = RoundToggleButton(title: "T")
    private let fButton = RoundToggleButton(title: "F")
    private let jButton = RoundToggleButton(title: "J")
    private let pButton = RoundToggleButton(title: "P")
    private let completeButton = RoundButton()
    lazy private var mbtiButtonList = [eButton, iButton, sButton, nButton,
                                       tButton, fButton, jButton, pButton]
    
    
    let viewModel = NicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.profile.title
        configureViewType()
        configureAction()
        bindData()
    }
    
    override func configureHierarchy() {
        view.addSubview(profileView)
        view.addSubview(nicknameField)
        view.addSubview(validLabel)
        view.addSubview(mbtiLabel)
        view.addSubview(firstMbtiStackView)
        view.addSubview(secondMbtiStackView)
        view.addSubview(completeButton)
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
        
    }
    
    override func configureUI() {
        nicknameField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameField.clearButtonMode = .whileEditing
        validLabel.font = FontType.tertiary
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
    
    }
}

extension NicknameViewController {
    private func configureViewType(){
        switch viewModel.viewType {
        case .add:
            nicknameField.text = ""
        case .edit:
            nicknameField.text = UserManager.nickname
            configureSaveBarButtonItem()
            completeButton.isHidden = true
        }
    }
    
    private func configureSaveBarButtonItem(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        save.tintColor = .black
        navigationItem.rightBarButtonItem = save
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
            }else{
                self?.completeButton.isEnabled = false
                self?.completeButton.backgroundColor = .dark_gray
            }
        }
        
        viewModel.outputSaveButtonClicked.bind { [weak self] value in
            if let type = self?.viewModel.viewType {
                switch type {
                case .add:
                    self?.transitionScene(PolaroidTabBarController())
                case .edit:
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
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func mbtiButtonClicked(sender: RoundToggleButton){
        viewModel.inputMbtiButtonClicked.value = sender.tag
    }
}

