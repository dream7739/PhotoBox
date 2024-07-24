//
//  UnderLineTextField.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import SnapKit

final class UnderLineTextField : UITextField {
    private let underline = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        tintColor = .theme_blue
        textColor = .black
        
        addSubview(underline)
        underline.backgroundColor = .dark_gray
        underline.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setLineColor(type: TextFieldType){
        switch type {
        case .normal:
            underline.backgroundColor = UIColor.dark_gray
        case .valid:
            underline.backgroundColor = UIColor.black
        case .inValid:
            underline.backgroundColor = UIColor.theme_blue
        }
    }
    
}

extension UnderLineTextField {
    enum TextFieldType {
        case normal
        case valid
        case inValid
    }
}
