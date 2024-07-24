//
//  RoundProfileView.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit
import SnapKit

final class RoundProfileView: UIView {
    let profileImage = RoundImageView(type: .highlight)
    private let cameraImage = UIImageView()

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
        layer.cornerRadius = frame.width / 2
    }
    
    func configureHierarchy(){
        addSubview(profileImage)
        addSubview(cameraImage)
    }
    
    func configureLayout(){
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalTo(profileImage).inset(5)
        }
    }
    
    func configureUI(){
        cameraImage.image = UIImage(systemName: "camera.fill")
        cameraImage.contentMode = .center
        cameraImage.tintColor = .white
        cameraImage.backgroundColor = UIColor.theme_blue
        cameraImage.layer.cornerRadius = 13
        cameraImage.clipsToBounds = true
    }
    
}
