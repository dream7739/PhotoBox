//
//  NetworkViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 8/3/24.
//

import UIKit
import SnapKit

protocol NetworkDelegate: UIViewController {
    func retryNetworkCall()
}

final class NetworkViewController: BaseViewController {
    private let networkView = NetworkView()
    var delegate: NetworkDelegate?
    
    override func configureHierarchy() { 
        view.addSubview(networkView)
    }
    
    override func configureLayout() {
        networkView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        networkView.retryButton.addTarget(self, action: #selector(retryButtonClicked), for: .touchUpInside)
    }
    
    @objc private func retryButtonClicked(){
        delegate?.retryNetworkCall()
        
        if NetworkMonitor.shared.isConnected {
            NetworkMonitor.shared.dismissNetworkWindow()
        }
    }
    
}
