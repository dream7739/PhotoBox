//
//  NetworkView.swift
//  Polaroid
//
//  Created by 홍정민 on 7/29/24.
//

import UIKit
import SnapKit

final class NetworkView: UIView {
    private let networkImage = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let retryButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
        addSubview(networkImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(retryButton)
    }
    
    private func configureLayout(){
        networkImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(networkImage.snp.bottom).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalTo(networkImage)
        }
        
        retryButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
        }
    }
    
    private func configureUI(){
        backgroundColor = .white
        
        networkImage.image = ImageType.wifi
        networkImage.tintColor = .dark_gray
        
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "네트워크 연결이 원할하지 않습니다"
        
        descriptionLabel.font = FontType.tertiary
        descriptionLabel.textColor = .dark_gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = "네트워크 연결 상태를 확인하고\n다시 시도해 주세요"
        
        retryButton.layer.cornerRadius = 20
        retryButton.backgroundColor = .black
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.setTitle("다시 시도", for: .normal)
        
        retryButton.addTarget(self, action: #selector(retryButtonClicked), for: .touchUpInside)
    }
    
    @objc private func retryButtonClicked(){
        if NetworkMonitor.shared.isConnected {
            NetworkMonitor.shared.dismissNetworkWindow()
        }
    }

}
