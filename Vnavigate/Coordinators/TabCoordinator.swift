//
//  TabCoordinator.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class TabCoordinator {

    private let tabBarController: UITabBarController
    private let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
    private let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
    private let favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController())

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        tabBarController.tabBar.tintColor = CustomColor.accent
        tabBarController.tabBar.unselectedItemTintColor = CustomColor.dark

        homeCoordinator.start()
        profileCoordinator.start()
        favoritesCoordinator.start()

        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            profileCoordinator.navigationController,
            favoritesCoordinator.navigationController,
        ]
    }
}
