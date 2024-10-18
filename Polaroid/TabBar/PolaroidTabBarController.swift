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
        let randomPhotoVC = UINavigationController(rootViewController: RandomPhotoViewController(viewModel: RandomPhotoViewModel()))
        let searchPhotoVC = UINavigationController(rootViewController: SearchPhotoViewController())
        let likePhotoVC = UINavigationController(rootViewController: PhotoLikeViewController())
        
        let topic = UITabBarItem(title: nil, image: Design.TabImage.tab_trend_inactive, tag: 0)
        topic.selectedImage = Design.TabImage.tab_trend
        topicPhotoVC.tabBarItem = topic
        
        let random = UITabBarItem(title: nil, image: Design.TabImage.tab_random_inactive, tag: 1)
        random.selectedImage = Design.TabImage.tab_random
        randomPhotoVC.tabBarItem = random
        
        let search = UITabBarItem(title: nil, image: Design.TabImage.tab_search_inactive, tag: 2)
        search.selectedImage = Design.TabImage.tab_search
        searchPhotoVC.tabBarItem = search
        
        let like = UITabBarItem(title: nil, image: Design.TabImage.tab_like_inactive, tag: 3)
        like.selectedImage = Design.TabImage.tab_like
        likePhotoVC.tabBarItem = like
        
        setViewControllers(
            [
                topicPhotoVC,
                randomPhotoVC,
                searchPhotoVC,
                likePhotoVC
            ],
            animated: true
        )
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
