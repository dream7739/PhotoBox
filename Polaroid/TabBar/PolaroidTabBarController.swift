//
//  PolaroidTabBarController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit

final class PolaroidTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTabBarAppearance()
    }
    
    private func configureTabBar(){
        //main, search, like
        let topicPhotoVC = UINavigationController(rootViewController: TopicPhotoViewController())
        let searchPhotoVC = UINavigationController(rootViewController: SearchPhotoViewController())
        let likePhotoVC = UINavigationController(rootViewController: PhotoLikeViewController())
        
        let topic = UITabBarItem(title: nil, image: UIImage(named: "tap_trend_inactive"), tag: 0)
        topic.selectedImage = UIImage(named: "tap_trend")
        topicPhotoVC.tabBarItem = topic
        
        let search = UITabBarItem(title: nil, image: UIImage(named: "tab_search_inactive"), tag: 1)
        search.selectedImage = UIImage(named: "tab_search")
        searchPhotoVC.tabBarItem = search
        
        let like = UITabBarItem(title: nil, image: UIImage(named: "tab_like_inactive"), tag: 2)
        like.selectedImage = UIImage(named: "tab_like")
        likePhotoVC.tabBarItem = like
        
        setViewControllers([topicPhotoVC, searchPhotoVC, likePhotoVC], animated: true)
    }
    
    private func configureTabBarAppearance(){
        let appearacnce = UITabBarAppearance()
        appearacnce.configureWithTransparentBackground()
        appearacnce.backgroundColor = .white
        appearacnce.stackedLayoutAppearance.selected.iconColor = .black
        tabBar.standardAppearance = appearacnce
        tabBar.scrollEdgeAppearance = appearacnce
    }
    
}
