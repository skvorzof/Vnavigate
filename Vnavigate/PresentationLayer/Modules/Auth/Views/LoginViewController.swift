//
//  LoginViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
// +79000000000 sms 000000

import UIKit

final class LoginViewController: UIViewController {

    private let coordinator: AuthCoordinator

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "С возвращением".uppercased()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = CustomColor.accent
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона для входа в приложение"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var phoneField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.placeholder = "+7 (...) ...-..-.."
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.delegate = self
        return field
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подтвердить".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = CustomColor.accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapsendButton), for: .touchUpInside)
        return button
    }()

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setSubviews(subviews: titleLabel, descriptionLabel, phoneField, sendButton)
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
    @objc private func didTapsendButton() {
        if let text = phoneField.text, !text.isEmpty {
            AuthService.shared.startAuth(phoneNumber: text) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator.coordinateToConfirmLogin(phoneNumber: text)
                case .failure(let error):
                    self?.showAlert(with: "Ошибка", and: "\(error.localizedDescription)")
                }
            }
        }
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if view.frame.height < 700 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let bottomSpace = view.frame.height - (sendButton.frame.origin.y + sendButton.frame.height)
                view.frame.origin.y -= keyboardHeight - bottomSpace + 20
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == phoneField) && textField.text == "" {
            textField.text = "+7("
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField {
            let res = phoneMask(phoneField: phoneField, textField: textField, range, string)
            return res.result
        }
        return true
    }
}

// MARK: - Set constraints
extension LoginViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),

            phoneField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            phoneField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            phoneField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            phoneField.heightAnchor.constraint(equalToConstant: 50),

            sendButton.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 70),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
