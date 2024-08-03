//
//  NetworkViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 8/3/24.
//

import UIKit
import SnapKit

final class NetworkViewController: BaseViewController {
    private let networkView = NetworkView()
    
    override func configureHierarchy() { 
        view.addSubview(networkView)
    }
    
    override func configureLayout() {
        networkView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
