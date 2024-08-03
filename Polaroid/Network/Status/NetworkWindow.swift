//
//  NetworkWindow.swift
//  Polaroid
//
//  Created by 홍정민 on 8/3/24.
//

import UIKit

final class NetworkWindow: UIWindow {
    private let networkViewController = NetworkViewController()
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        rootViewController = networkViewController
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        windowLevel = .statusBar
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
