//
//  EmptyView.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    private let descriptionLabel = UILabel()
    
    init(type: EmptyView.EmptyType) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureUI()
        setDescription(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDescription(_ type: EmptyView.EmptyType){
        descriptionLabel.text = type.rawValue
    }
}

extension EmptyView{
    enum EmptyType: String{
        case searchInit = "사진을 검색해보세요"
        case search = "검색 결과가 없습니다"
        case like = "저장된 사진이 없어요"
    }
}

extension EmptyView {
    func configureHierarchy(){
        addSubview(descriptionLabel)
    }
    
    func configureLayout(){
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
    }
    
    func configureUI(){
        backgroundColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        descriptionLabel.textAlignment = .center
    }
}
