//
//  AuthCoordinator.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
//

import UIKit

final class AuthCoordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let authViewController = AuthViewController(coordinator: self)
        authViewController.navigationItem.backButtonDisplayMode = .minimal
        navigationController.viewControllers = [authViewController]
    }

    func coordinateToRegister() {
        let registerViewController = RegisterViewController(coordinator: self)
        registerViewController.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(registerViewController, animated: true)
    }

    func coordinateToConfirmRegister(phoneNumber: String) {
        let confirmRegisterViewModel = ConfirmRegisterViewModel(phoneNumber: phoneNumber)
        let confirmRegisterViewController = ConfirmRegisterViewController(coordinator: self, viewModel: confirmRegisterViewModel)
        navigationController.pushViewController(confirmRegisterViewController, animated: true)
    }

    func coordinateToLogin() {
        let loginViewController = LoginViewController(coordinator: self)
        loginViewController.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func coordinateToConfirmLogin(phoneNumber: String) {
        let confirmLoginViewModel = ConfirmLoginViewModel(phoneNumber: phoneNumber)
        let confirmLoginViewController = ConfirmLoginViewController(coordinator: self, viewModel: confirmLoginViewModel)
        navigationController.pushViewController(confirmLoginViewController, animated: true)
    }

    func coordinateToHomeFlow() {
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        let rootViewController = UITabBarController()

        window?.rootViewController = rootViewController

        let tabCoordinator = TabCoordinator(tabBarController: rootViewController)
        tabCoordinator.start()

        UIView.transition(with: window!, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
    }
}
