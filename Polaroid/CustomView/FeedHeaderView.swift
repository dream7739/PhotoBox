//
//  FeedHeaderView.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import UIKit
import Kingfisher
import SnapKit

final class FeedHeaderView: UIView {
    private let userProfileImage = UIImageView()
    private let usernameLabel = UILabel()
    private let createDateLabel = UILabel()
    private let heartButton = UIButton()
    private let heartImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userProfileImage.layer.cornerRadius = userProfileImage.frame.width / 2
    }
    
    private func configureHierarchy(){
        addSubview(userProfileImage)
        addSubview(usernameLabel)
        addSubview(createDateLabel)
        addSubview(heartButton)
        addSubview(heartImage)
    }
    
    private func configureLayout(){
        userProfileImage.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImage)
            make.leading.equalTo(userProfileImage.snp.trailing).offset(8)
            make.trailing.equalTo(heartButton.snp.leading).inset(10)
        }
        
        createDateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(2)
            make.leading.equalTo(usernameLabel)
            make.trailing.equalTo(heartButton.snp.leading).inset(10)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        heartImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureUI(){
        userProfileImage.clipsToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        
        usernameLabel.font = FontType.tertiary
        
        createDateLabel.font = .systemFont(ofSize: 13, weight: .semibold)

        heartImage.image = UIImage(systemName: "heart")
    }
    
    
    func configureHeaderView(profileImage: String, userName: String, createDate: String){
        if let url = URL(string: profileImage) {
            userProfileImage.kf.setImage(with: url)
        }else{
            userProfileImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
        }
        
        usernameLabel.text = userName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let convertDate = dateFormatter.date(from: createDate) ?? Date()
        
        let dateString = dateFormatter.string(from: convertDate)
        
        createDateLabel.text = dateString + " 게시됨"
        
    }

}
