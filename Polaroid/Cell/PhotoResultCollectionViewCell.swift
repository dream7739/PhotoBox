//
//  PhotoResultCollectionViewCell.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import Kingfisher
import RealmSwift
import SnapKit

protocol ResultLikeDelegate: AnyObject {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool)
}

final class PhotoResultCollectionViewCell: BaseCollectionViewCell {
    private let photoImage = UIImageView()
    private let starStackView = UIStackView()
    private let starImage = UIImageView()
    private let starCountLabel = UILabel()
    private let userImage = UIImageView()
    private let usernameLabel = UILabel()
    private let likeImage = UIImageView()
    private let likeButton = UIButton()
    
    weak var delegate: ResultLikeDelegate?
    var indexPath: IndexPath?
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                likeImage.image = Design.ImageType.like_circle
            }else{
                likeImage.image = Design.ImageType.like_circle_inactive
            }
        }
    }
    
    private let repository = RealmRepository()
    
    override func configureHierarchy() {
        contentView.addSubview(photoImage)
        contentView.addSubview(starStackView)
        contentView.addSubview(userImage)
        contentView.addSubview(usernameLabel)
        starStackView.addArrangedSubview(starImage)
        starStackView.addArrangedSubview(starCountLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeImage)
    }
    
    override func configureLayout() {
        photoImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView).multipliedBy(0.88)
        }
        
        starStackView.snp.makeConstraints { make in
            make.centerY.equalTo(usernameLabel)
            make.trailing.equalTo(photoImage).offset(-2)
        }

        starImage.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        userImage.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom).offset(6)
            make.leading.equalTo(contentView).offset(8)
            make.size.equalTo(20)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImage)
            make.leading.equalTo(userImage.snp.trailing).offset(4)
            make.trailing.equalTo(starStackView.snp.leading).offset(-8)
        }
        
        usernameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        starStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        likeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(photoImage)
            make.size.equalTo(50)
        }
        
        likeImage.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(30)
        }
    }
    
    override func configureUI() {
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
        
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        usernameLabel.textColor = .darkGray
        usernameLabel.font = Design.FontType.quaternary
        
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        
        starImage.image = Design.ImageType.like
        starImage.tintColor = .lightGray
        
        starCountLabel.textColor = .lightGray
        starCountLabel.font = Design.FontType.quaternary
        
        likeImage.image = Design.ImageType.like_circle_inactive
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)

    }
    
}

extension PhotoResultCollectionViewCell {
    enum EnterPoint {
        case topicPhoto
        case searchPhoto
        case likePhoto
    }
    
    func configureData(_ enterPoint: EnterPoint, _ data: PhotoResult){
        switch enterPoint {
        case .topicPhoto: 
            if let url = URL(string: data.urls.small){
                photoImage.kf.setImage(with: url)
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
            if let userImageURL = URL(string: data.user.profile_image.medium) {
                userImage.kf.setImage(with: userImageURL)
            } else{
                userImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
            likeImage.isHidden = true
            likeButton.isHidden = true
        case .searchPhoto:
            if let url = URL(string: data.urls.small){
                photoImage.kf.setImage(with: url)
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
            if let userImageURL = URL(string: data.user.profile_image.medium) {
                userImage.kf.setImage(with: userImageURL)
            } else{
                userImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
        case .likePhoto:
            if let image = ImageFileManager.loadImageToDocument(filename: data.id){
                photoImage.image = image
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
            if let userImageURL = URL(string: data.user.profile_image.medium) {
                userImage.kf.setImage(with: userImageURL)
            } else{
                userImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
        }
        userImage.layer.cornerRadius = 10
        photoImage.layer.cornerRadius = 10
        usernameLabel.text = data.user.name
        starCountLabel.text = data.likes.formatted(.number)
        isClicked = repository.isExistLike(id: data.id)
    }
    
    @objc func likeButtonClicked(){
        guard let indexPath else { return }
        isClicked.toggle()
        delegate?.likeButtonClicked(indexPath, isClicked)
    }
}

