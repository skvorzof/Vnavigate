//
//  ProfileCoordinator.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class ProfileCoordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let profileViewModel = ProfileViewModel()
        let profileViewController = ProfileViewController(coordinator: self, viewModel: profileViewModel)
        profileViewController.title = "Профиль"
        profileViewController.navigationItem.backButtonDisplayMode = .minimal
        navigationController.viewControllers = [profileViewController]
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"))
    }

    func coordinateToProfilePhotos(author: Author) {
        let profilePhotosViewModel = ProfilePhotosViewModel(author: author)
        let profilePhotosViewContoller = ProfilePhotosViewContoller(coordinator: self, viewModel: profilePhotosViewModel)
        profilePhotosViewContoller.title = "Фотографии"
        navigationController.pushViewController(profilePhotosViewContoller, animated: true)
    }

    func coordinateToPhotosDetails(photo: Photo) {
        let profilePhotosDetailViewModel = ProfilePhotosDetailViewModel(photo: photo)
        let profilePhotosDetailViewController = ProfilePhotosDetailViewController(viewModel: profilePhotosDetailViewModel)
        profilePhotosDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.present(profilePhotosDetailViewController, animated: true)
    }

    func coordinateToPostDetails(post: Post) {
        let profilePostDetailViewModel = ProfilePostDetailViewModel(post: post)
        let profilePostDetailViewController = ProfilePostDetailViewController(viewModel: profilePostDetailViewModel)
        navigationController.pushViewController(profilePostDetailViewController, animated: true)
    }

    func coordinateToSignOut() {
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else { return }
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
    }
}
