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
        configureNav()
    }
    
    func configureHierarchy(){ }
    func configureLayout(){ }
    func configureUI(){ }
    func configureNav(){
        let backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
    }
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
        
        view.makeToast(
            text,
            duration: 1.0,
            point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 1.3),
            title: nil,
            image: nil,
            style: toastStyle,
            completion: nil
        )
    }
    
    func showAlert(_ title: String?, _ message: String?,
                   _ completion: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: completion)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func configureImageFile(_ isClicked: Bool, _ data: PhotoResult){
        let imageID = data.id
        let imageURL = data.urls.small
        let profileURL = data.user.profile_image.medium
        
        if isClicked {
            imageURL.loadImage { [weak self] result in
                switch result {
                case .success(let value):
                    ImageFileManager.saveImageToDocument(image: value, filename: imageID)
                case .failure(let error):
                    self?.showToast(error.localizedDescription)
                }
            }
            
            profileURL.loadImage { [weak self] result in
                switch result {
                case .success(let value):
                    ImageFileManager.saveImageToDocument(image: value, filename: imageID + "_profile")
                case .failure(let error):
                    self?.showToast(error.localizedDescription)
                }
            }
        }else{
            ImageFileManager.removeImageFromDocument(filename: imageID)
            ImageFileManager.removeImageFromDocument(filename: imageID + "_profile")
        }
    }
}
