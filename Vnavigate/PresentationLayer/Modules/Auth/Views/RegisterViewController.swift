//
//  RegisterViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 07.02.2023.
//

import UIKit

final class RegisterViewController: UIViewController {

    private let coordinator: AuthCoordinator

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Зарегистрироваться".uppercased()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш номер будет использоваться для входа в аккаунт"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomColor.gray
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
        field.delegate = self
        field.keyboardType = .numberPad
        return field
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = CustomColor.accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    private lazy var conventionLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажимая кнопку “Далее” Вы принимаете пользовательское Соглашение и политику конфедициальности"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomColor.gray
        return label
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

        phoneField.delegate = self
        phoneField.keyboardType = .numberPad

        setSubviews(subviews: titleLabel, numberLabel, descriptionLabel, phoneField, nextButton, conventionLabel)
        setUI()
        setConstraints()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }

    private func setUI() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Actions
    @objc
    private func didTapNextButton() {
        if let text = phoneField.text, !text.isEmpty {
            AuthService.shared.startAuth(phoneNumber: text) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator.coordinateToConfirmRegister(phoneNumber: text)
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
            let bottomSpace = view.frame.height - (conventionLabel.frame.origin.y + conventionLabel.frame.height)
            view.frame.origin.y -= keyboardHeight - bottomSpace + 20
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = PhoneNumberFofmatter.shared.formatter(mask: "+# (###) ###-##-##", phoneNumber: newString)
        return false
    }
}

// MARK: - Set constraints
extension RegisterViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            numberLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70),
            numberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),

            phoneField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            phoneField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            phoneField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            phoneField.heightAnchor.constraint(equalToConstant: 50),

            nextButton.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 70),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            conventionLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            conventionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            conventionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
}
