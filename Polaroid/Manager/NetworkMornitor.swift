//
//  NetworkMornitor.swift
//  Polaroid
//
//  Created by 홍정민 on 7/29/24.
//

import Foundation
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
            }
        }
    }
    
     func stopMonitoring(){
        monitor.cancel()
    }
    
}
