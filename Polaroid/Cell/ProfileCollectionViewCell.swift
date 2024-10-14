//
//  ProfileCollectionViewCell.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    
    private let profileImage = RoundImageView(type: .regular)
        
    var isClicked = false {
        didSet{
            if isClicked {
                profileImage.setHighLight()
            }else{
                profileImage.setRegular()
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImage)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ProfileCollectionViewCell {
    func configureData(data: Design.ProfileType){
        profileImage.image = UIImage(named: data.rawValue)
    }
}
