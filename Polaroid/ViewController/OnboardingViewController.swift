//
//  OnboardingViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    private let titleImage = UIImageView()
    private let launchImage = UIImageView()
    private let nameLabel = UILabel()
    private let startButton = RoundButton()
    
    override func configureHierarchy() {
        [titleImage, launchImage, nameLabel, startButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.width.equalTo(270)
            make.height.equalTo(60)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        launchImage.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(38)
            make.width.equalTo(260)
            make.height.equalTo(launchImage.snp.width).multipliedBy(1.4)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(launchImage.snp.bottom).offset(8)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        titleImage.contentMode = .scaleAspectFill
        titleImage.image = UIImage(named: "launch")
        launchImage.contentMode = .scaleAspectFill
        launchImage.image = UIImage(named: "launchImage")
        nameLabel.text = "홍정민"
        nameLabel.font = .boldSystemFont(ofSize: 20)
        startButton.setTitle("시작하기", for: .normal)
        startButton.addTarget( self, action: #selector(startButtonClicked), for: .touchUpInside)

    }
}

extension OnboardingViewController {
    @objc private func startButtonClicked(){
        let nicknameVC = NicknameViewController()
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
}
