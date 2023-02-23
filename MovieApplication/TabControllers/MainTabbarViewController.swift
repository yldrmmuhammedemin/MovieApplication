//
//  ViewController.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import UIKit
class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: ComingSoonViewController())
        let vc4 = UINavigationController(rootViewController: FavoritesViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.title = "Search"
        vc3.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.title = "Coming Soon"
        vc4.tabBarItem.image = UIImage(systemName: "heart.circle")
        vc4.tabBarItem.title = "Favorites"
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    



}

