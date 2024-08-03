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
    
    func transitionScene<T: UIViewController>(_ viewController: T){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func configureImageFile(_ isClicked: Bool, _ data: PhotoResult){
        let imageID = data.id
        let imageURL = data.urls.small
        let profileURL = data.user.profile_image.medium
        
        if isClicked {
            downloadImage(imageURL: imageURL, profileURL: profileURL, imageID: imageID)
        }else{
            removeImage(imageID: imageID)
        }
    }
    
    func downloadImage(imageURL: String, profileURL: String, imageID: String){
        let group = DispatchGroup()
        var isFailed = false
        
        group.enter()
        DispatchQueue.global(qos: .utility).async(group: group) {
            imageURL.loadImage { result in

                switch result {
                case .success(let value):
                    ImageFileManager.saveImageToDocument(image: value, filename: imageID)
                case .failure:
                    isFailed = true
                }
                group.leave()
            }
        }
    
        group.enter()
        DispatchQueue.global(qos: .utility).async(group: group){
            profileURL.loadImage { result in
                switch result {
                case .success(let value):
                    ImageFileManager.saveImageToDocument(image: value, filename: imageID + Literal.profileFileName)
                case .failure:
                    isFailed = true
                }
                group.leave()
            }
        }

        group.notify(queue: .main){
            if isFailed {
                self.showToast("이미지를 다운받지 못했습니다")
            }
        }
    }
    
 func removeImage(imageID: String){
        ImageFileManager.removeImageFromDocument(filename: imageID)
        ImageFileManager.removeImageFromDocument(filename: imageID + Literal.profileFileName)
    }
}
