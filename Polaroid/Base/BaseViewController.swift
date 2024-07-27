//
//  BaseViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit
import Toast

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy(){ }
    func configureLayout(){ }
    func configureUI(){ }
    

}

extension BaseViewController {
    func transitionScene<T: UIViewController>(_ viewController: T){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func showToast(_ text: String){
        var toastStyle = ToastStyle()
        toastStyle.cornerRadius = 20
        toastStyle.horizontalPadding = 15
        toastStyle.backgroundColor = .dark_gray
        
        view.makeToast(
            text,
            duration: 1.0,
            point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 1.4),
            title: nil,
            image: nil,
            style: toastStyle,
            completion: nil
        )
        
    }
}
