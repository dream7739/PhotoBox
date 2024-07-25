//
//  TitleSupplementaryView.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import UIKit
import SnapKit

final class TitleSupplementaryView: UICollectionReusableView {
    
    let titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureHierarchy(){
        addSubview(titleLabel)
    }
    
    func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
