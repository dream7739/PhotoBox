//
//  ThrottleButton.swift
//  Polaroid
//
//  Created by 홍정민 on 8/2/24.
//

import UIKit

class ThrottleButton: UIButton {
    private var enable = true
    private var delay: Double = 0
    private var callback: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func throttle(delay: Double, callback: @escaping () -> (Void)){
        self.delay = delay
        self.callback = callback
    }
    
    @objc func buttonClicked(){
        if enable {
            callback?()
            enable.toggle()
            waitForTime()
        }
    }
    
    private func waitForTime(){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){ [weak self] in
            self?.enable = true
        }
    }
    
}
