//
//  ConfirmRegisterViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
//

import UIKit

final class ConfirmRegisterViewController: UIViewController {

    private let coordinator: AuthCoordinator
    private let viewModel: ConfirmRegisterViewModel

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Подтверждение регистрации"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = CustomColor.accent
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы отправили SMS с кодом на номер"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+7"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из SMS"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomColor.gray
        return label
    }()

    private lazy var smsField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.placeholder = "* * * * * *"
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.textContentType = .oneTimeCode
        return field
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

    private lazy var bannerImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "auth_check")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(coordinator: AuthCoordinator, viewModel: ConfirmRegisterViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        phoneNumberLabel.text = viewModel.phoneNumber

        setSubviews(subviews: titleLabel, infoLabel, phoneNumberLabel, instructionLabel, smsField, registerButton, bannerImage)
        setUI()
        setConstraints()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setUI() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }

    // MARK: - Actions
    @objc private func didTapRegisterButton() {
        if let text = smsField.text, !text.isEmpty {
            AuthService.shared.verifyCode(smsCode: text) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator.coordinateToHomeFlow()
                case .failure(let error):
                    self?.showAlert(with: "Ошибка", and: "\(error.localizedDescription)")
                }
            }
        }
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = view.frame.height - (registerButton.frame.origin.y + registerButton.frame.height)
            view.frame.origin.y -= keyboardHeight - bottomSpace + 20
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - Set constraints
extension ConfirmRegisterViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            phoneNumberLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            phoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            instructionLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 100),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),

            smsField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
            smsField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            smsField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            smsField.heightAnchor.constraint(equalToConstant: 50),

            registerButton.topAnchor.constraint(equalTo: smsField.bottomAnchor, constant: 70),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            registerButton.heightAnchor.constraint(equalToConstant: 50),

            bannerImage.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 50),
            bannerImage.widthAnchor.constraint(equalToConstant: 86),
            bannerImage.heightAnchor.constraint(equalToConstant: 100),
            bannerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
