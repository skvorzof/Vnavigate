//
//  ProfileInfoCell.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import UIKit

protocol ProfileInfoCellDelegate: AnyObject {
    func didTapPhotosButton(author: Author)
    func didTapOutButton()
}

final class ProfileInfoCell: UICollectionViewCell {

    weak var delegate: ProfileInfoCellDelegate?
    private var author: Author?
    private let avatar = CircularImageView()

    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let profession: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = CustomColor.gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let publicationsLabel: UILabel = {
        let label = UILabel()
        label.text = "1400\n публикаций"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let followLabel: UILabel = {
        let label = UILabel()
        label.text = "447\n подписок"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "161 тыс.\n подписчиков"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [publicationsLabel, followLabel, followersLabel])
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = CustomColor.dark
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    private lazy var historyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = CustomColor.dark
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    private lazy var photoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = CustomColor.dark
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postButton, historyButton, photoButton])
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()

    private let headerPhotosLabel: UILabel = {
        let label = UILabel()
        label.text = "Фотографии"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private let countPhotos: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = CustomColor.gray
        label.text = "15"
        return label
    }()

    private lazy var photosButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(didTapPhotosButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        contentView.isUserInteractionEnabled = false

        setSubviews(
            avatar, name, profession, editButton, infoStackView, buttonsStackView, headerPhotosLabel,
            countPhotos,
            photosButton)
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(author: Author) {
        self.author = author
        avatar.image = UIImage(named: author.avatar ?? "")
        name.text = author.name
        profession.text = author.profession
        countPhotos.text = "\(author.photos?.count ?? 0)"

        if author.authorId != "0" {
            let buttonText = author.isFriend ? "Удалить из друзей" : "Добавить в друзья"
            editButton.setTitle(buttonText, for: .normal)
            editButton.backgroundColor = CustomColor.accent
            editButton.addTarget(self, action: #selector(addToFriend), for: .touchUpInside)
        } else {
            editButton.addTarget(self, action: #selector(didTapOutButton), for: .touchUpInside)
        }
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }

    // MARK: - Actions
    @objc private func addToFriend() {
        if let author {
            let friend = author.isFriend ? false : true
            author.setValue(friend, forKey: "isFriend")
            CoreDataManager.shared.save()

            let buttonText = author.isFriend ? "Удалить из друзей" : "Добавить в друзья"
            editButton.setTitle(buttonText, for: .normal)
        }
    }

    @objc private func didTapPhotosButton() {
        guard let author = author else { return }
        delegate?.didTapPhotosButton(author: author)
    }

    @objc private func didTapOutButton() {
        delegate?.didTapOutButton()
    }
}

// MARK: - Set constraints
extension ProfileInfoCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            avatar.topAnchor.constraint(equalTo: topAnchor),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor),

            name.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 7),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),

            profession.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            profession.leadingAnchor.constraint(equalTo: name.leadingAnchor),

            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            infoStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            buttonsStackView.heightAnchor.constraint(equalToConstant: 30),
            buttonsStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            headerPhotosLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 40),
            headerPhotosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            countPhotos.topAnchor.constraint(equalTo: headerPhotosLabel.topAnchor),
            countPhotos.leadingAnchor.constraint(equalTo: headerPhotosLabel.trailingAnchor, constant: 10),

            photosButton.widthAnchor.constraint(equalToConstant: 30),
            photosButton.topAnchor.constraint(equalTo: countPhotos.topAnchor, constant: 0),
            photosButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
