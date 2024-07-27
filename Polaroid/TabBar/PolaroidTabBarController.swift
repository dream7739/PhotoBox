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
        let topicPhotoVC = UINavigationController(rootViewController: TopicPhotoViewController())
        let searchPhotoVC = UINavigationController(rootViewController: SearchPhotoViewController())
        let likePhotoVC = UINavigationController(rootViewController: PhotoLikeViewController())
        
        let topic = UITabBarItem(title: nil, image: TapImage.tab_trend_inactive, tag: 0)
        topic.selectedImage = TapImage.tab_trend
        topicPhotoVC.tabBarItem = topic
        
        let search = UITabBarItem(title: nil, image: TapImage.tab_search_inactive, tag: 1)
        search.selectedImage = TapImage.tab_search
        searchPhotoVC.tabBarItem = search
        
        let like = UITabBarItem(title: nil, image: TapImage.tab_like_inactive, tag: 2)
        like.selectedImage = TapImage.tab_like
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
