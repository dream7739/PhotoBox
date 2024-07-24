//
//  BaseCollectionViewCell.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){ }
    func configureLayout(){ }
    func configureUI(){ }
    
}
