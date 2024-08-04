//
//  NetworkMornitor.swift
//  Polaroid
//
//  Created by 홍정민 on 7/29/24.
//

import UIKit
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    var isConnected = false
    
    private init(){ }
    
    func startMonitoring(){
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
            }else{
                self?.isConnected = false
                self?.presentNetworkWindow()
            }
        }
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
    
    func presentNetworkWindow(){
        DispatchQueue.main.async {
            guard let topVC = UIApplication.topViewController() as? BaseViewController else { return }

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let networkWindow = NetworkWindow(windowScene: windowScene)
                networkWindow.networkViewController.delegate = topVC

                networkWindow.makeKeyAndVisible()
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.networkWindow = networkWindow
                
            }
        }
    }
    
    func dismissNetworkWindow(){
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.networkWindow = nil
            }
        }
    }
    
}
