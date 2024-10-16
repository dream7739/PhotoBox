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
    let userProfileImage = UIImageView()
    let usernameLabel = UILabel()
    let createDateLabel = UILabel()
    let likeButton = UIButton()
    let likeImage = UIImageView()
    
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                likeImage.image = Design.ImageType.like_selected
            }else{
                likeImage.image = Design.ImageType.like
            }
        }
    }
    
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
        addSubview(likeButton)
        addSubview(likeImage)
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
            make.trailing.equalTo(likeButton.snp.leading).inset(10)
        }
        
        createDateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(2)
            make.leading.equalTo(usernameLabel)
            make.trailing.equalTo(likeButton.snp.leading).inset(10)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        likeImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureUI(){
        userProfileImage.clipsToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        usernameLabel.font = Design.FontType.tertiary
        createDateLabel.font = Design.FontType.quarternary_bold
        likeImage.image = Design.ImageType.like
    }
    
   
}
