//
//  AuthViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
//

import UIKit

final class AuthViewController: UIViewController {

    private let coordinator: AuthCoordinator

    private let bannerImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "auth_bg")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = CustomColor.accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()

    private lazy var authButton: UIButton = {
        let button = UIButton()
        button.setTitle("Уже есть аккаунт", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(CustomColor.accent, for: .normal)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSubviews(subviews: bannerImage, registerButton, authButton)
        setConstraints()
    }

    private func setSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            bannerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            bannerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            registerButton.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 50),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            registerButton.heightAnchor.constraint(equalToConstant: 50),

            authButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30),
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc private func didTapRegisterButton() {
        coordinator.coordinateToRegister()
    }

    @objc private func didTapLoginButton() {
        coordinator.coordinateToLogin()
    }
}
