//
//  HomeCoordinator.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class HomeCoordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(coordinator: self, viewModel: homeViewModel)
        homeViewController.title = "Главная"
        navigationController.viewControllers = [homeViewController]
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))
    }

    func coordinateToHomePostDetail(post: Post) {
        let homePostDetailViewController = HomePostDetailViewController(post: post)
        navigationController.pushViewController(homePostDetailViewController, animated: true)
    }

    func coordinateToHomeAuthorProfile(author: Author) {
        print("coordinateToHomeAuthorProfile -> \(author.name)")
    }
}
