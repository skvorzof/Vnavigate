//
//  FavoritesCoordinator.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class FavoritesCoordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let favoritesViewModel = FavoritesViewModel()
        let favoritesViewController = FavoritesViewController(coordinator: self, viewModel: favoritesViewModel)
        favoritesViewModel.view = favoritesViewController
        favoritesViewController.title = "Избранное"
        favoritesViewController.navigationItem.backButtonDisplayMode = .minimal
        navigationController.viewControllers = [favoritesViewController]
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill"))
    }

    func coordinateToFavoritesDetails(post: Post) {
        let favoritesDetailsViewController = FavoritesDetailsViewController(post: post)
        navigationController.pushViewController(favoritesDetailsViewController, animated: true)
    }

    func coordinateToFavorites() {
        navigationController.popViewController(animated: true)
    }
}
