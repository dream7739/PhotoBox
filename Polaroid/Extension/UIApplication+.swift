//
//  UIApplication+.swift
//  Polaroid
//
//  Created by 홍정민 on 8/4/24.
//

import UIKit

extension UIApplication {
    static func topViewController(base: UIViewController? = configureRootViewController()) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
      
        
        return base
    }
    
    static func configureRootViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
           return windowScene.keyWindow?.rootViewController
        }
        
        return nil
    }

    
}
