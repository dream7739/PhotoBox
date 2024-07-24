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
    private let completeButton = RoundButton()
    let viewModel = NicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.profile.title
        configureAction()
        bindData()
    }
    
    override func configureHierarchy() {
        view.addSubview(profileView)
        view.addSubview(nicknameField)
        view.addSubview(validLabel)
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
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(nicknameField)
            make.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        switch viewModel.viewType {
        case .add:
            nicknameField.text = ""
        case .edit:
            addSaveBarButton()
            viewModel.inputNickname.value = UserManager.nickname
            nicknameField.text = UserManager.nickname
            completeButton.isHidden = true
        }
        
        nicknameField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameField.clearButtonMode = .whileEditing
        validLabel.font = FontType.tertiary
        completeButton.setTitle("완료", for: .normal)
    }
    
    private func configureAction(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nicknameField.addTarget(self, action: #selector(completeButtonClicked), for: .editingDidEndOnExit)
        
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
}

extension NicknameViewController {
    private func bindData(){
        viewModel.outputProfileImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.profileView.profileImage.image = UIImage(named: value)
        }
        
        viewModel.outputNicknameText.bind { [weak self] value in
            self?.validLabel.text = value
        }
        
        viewModel.outputNicknameValid.bind { [weak self] value in
            if value {
                self?.nicknameField.setLineColor(type: .valid)
                self?.validLabel.textColor = .black
            }else{
                self?.nicknameField.setLineColor(type: .inValid)
                self?.validLabel.textColor = .theme_blue
            }
        }
        
        viewModel.outputSaveButton.bind { [weak self] value in
            if let type = self?.viewModel.viewType {
                switch type {
                case .add:
                    self?.transitionScene(PolaroidTabBarController())
                case .edit:
                    self?.navigationController?.popViewController(animated: true)
                }
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
        viewModel.inputNickname.value = nicknameField.text!.trimmingCharacters(in: .whitespaces)
    }
    
    @objc private func completeButtonClicked(){
        viewModel.inputSaveButton.value = ()
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension NicknameViewController {
    private func addSaveBarButton(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        save.tintColor = .black
        navigationItem.rightBarButtonItem = save
    }
}
