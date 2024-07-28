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
    private let likeImage = UIImageView()
    private let likeButton = UIButton()
    
    weak var delegate: ResultLikeDelegate?
    var indexPath: IndexPath?
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                likeImage.image = ImageType.like_circle
            }else{
                likeImage.image = ImageType.like_circle_inactive
            }
        }
    }
    
    private let repository = RealmRepository()
    
    override func configureHierarchy() {
        contentView.addSubview(photoImage)
        contentView.addSubview(starStackView)
        starStackView.addArrangedSubview(starImage)
        starStackView.addArrangedSubview(starCountLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeImage)
    }
    
    override func configureLayout() {
        photoImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        starStackView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        starImage.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(photoImage)
            make.size.equalTo(50)
        }
        
        likeImage.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(30)
        }
    }
    
    override func configureUI() {
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
        
        starStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        starStackView.isLayoutMarginsRelativeArrangement = true
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.layer.cornerRadius = 10
        starStackView.backgroundColor = .deep_gray
        
        starImage.image = UIImage(systemName: "star.fill")
        starImage.tintColor = .systemYellow
        
        starCountLabel.textColor = .white
        starCountLabel.font = FontType.quaternary
        
        likeImage.image = ImageType.like_circle_inactive
        
        likeButton.addTarget( self, action: #selector(likeButtonClicked), for: .touchUpInside)

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
        case .searchPhoto:
            if let url = URL(string: data.urls.small){
                photoImage.kf.setImage(with: url)
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            starCountLabel.text = data.likes.formatted(.number)
            isClicked = repository.isExistLike(id: data.id)
        case .likePhoto:
            if let image = ImageFileManager.loadImageToDocument(filename: data.id){
                photoImage.image = image
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            starCountLabel.text = data.likes.formatted(.number)
            isClicked = repository.isExistLike(id: data.id)
        case .topicPhoto:
            if let url = URL(string: data.urls.small){
                photoImage.kf.setImage(with: url)
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            photoImage.layer.cornerRadius = 10
            likeImage.isHidden = true
            starCountLabel.text = data.likes.formatted(.number)
            isClicked = repository.isExistLike(id: data.id)
        }
    }
    
    @objc func likeButtonClicked(){
        guard let indexPath else { return }
        isClicked.toggle()
        delegate?.likeButtonClicked(indexPath, isClicked)
    }
}

