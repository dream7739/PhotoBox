//
//  PhotoResultCollectionViewCell.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import Kingfisher
import SnapKit

protocol ResultLikeDelegate: AnyObject {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool)
}

final class PhotoResultCollectionViewCell: UICollectionViewCell {
    private let photoImage = UIImageView()
    private let starStackView = UIStackView()
    private let starImage = UIImageView()
    private let starCountLabel = UILabel()
    private let likeImage = UIImageView()
    private let likeButton = UIButton()
    
    weak var delegate: ResultLikeDelegate?
    var keyword: String?
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
        likeButton.addTarget( self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(photoImage)
        contentView.addSubview(starStackView)
        starStackView.addArrangedSubview(starImage)
        starStackView.addArrangedSubview(starCountLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeImage)
    }
    
    func configureLayout() {
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
            make.size.equalTo(40)
        }
    }
    
    func configureUI() {
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
    }
    
}

extension PhotoResultCollectionViewCell {
    func configureData(_ data: PhotoResult){
        photoImage.kf.setImage(with: URL(string: data.urls.small))
        starCountLabel.text = data.likes.formatted(.number)
    }
    
    
    @objc func likeButtonClicked(){
        guard let indexPath else { return }
        isClicked.toggle()
        delegate?.likeButtonClicked(indexPath, isClicked)

    }
}
