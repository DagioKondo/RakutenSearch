//
//  MainTabBarController.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/04/09.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    
    func setupTab() {
        //        let netShoppingViewController = NetShoppingViewController()
//        let favoritesViewController = FavoritesViewController()
        let navigationController1 = UINavigationController(rootViewController: NetShoppingViewController.init())
        let navigationController2 = UINavigationController(rootViewController: FavoritesViewController.init())
        navigationController1.tabBarItem = UITabBarItem(title: "検索", image: UIImage(systemName: "magnifyingglass"), tag: 0)
//        netShoppingViewController.tabBarItem = UITabBarItem(title: "検索", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        navigationController2.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "star"), tag: 0)
        viewControllers = [navigationController1, navigationController2]
    }
}
