//
//  RandomCollectionVeiwCell.swift
//  Polaroid
//
//  Created by 홍정민 on 10/18/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RandomCollectionVeiwCell: BaseCollectionViewCell {
    
    private let pageView = UIView()
    private let pageLabel = UILabel()
    private let photoImageView = UIImageView()
    private let headerView = FeedHeaderView()
    
    private let repository = RealmRepository()
    weak var delegate: ResultLikeDelegate?
    var indexPath: IndexPath?
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                headerView.likeImage.image = Design.ImageType.like_selected
            } else{
                headerView.likeImage.image = Design.ImageType.like
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(pageView)
        pageView.addSubview(pageLabel)
        contentView.addSubview(headerView)
    }
    
    override func configureLayout() {
        pageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(pageView).inset(4)
            make.horizontalEdges.equalTo(pageView).inset(8)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        pageView.layer.cornerRadius = 10
        pageView.clipsToBounds = true
        pageView.backgroundColor = .darkGray
        pageLabel.text = "1/10"
        pageLabel.font = Design.FontType.quaternary
        pageLabel.textColor = .white
        headerView.usernameLabel.textColor = .white
        headerView.createDateLabel.textColor = .white
        headerView.likeImage.tintColor = .white

        headerView.likeImage.image = Design.ImageType.like
        headerView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    func configureData(_ data: PhotoResult, _ index: Int) {
        if let url = URL(string: data.urls.small) {
            photoImageView.kf.setImage(with: url)
        }
        headerView.usernameLabel.text = data.user.name
        headerView.createDateLabel.text = data.dateDescription
        
        if let profileURL = URL(string: data.user.profile_image.medium) {
            headerView.userProfileImage.kf.setImage(with: profileURL)
        }
        
        isClicked = repository.isExistLike(id: data.id)
            
        pageLabel.text = "\(index) / 10"
    }
    
    @objc func likeButtonClicked(){
        guard let indexPath else { return }
        isClicked.toggle()
        delegate?.likeButtonClicked(indexPath, isClicked)
    }
    
}
