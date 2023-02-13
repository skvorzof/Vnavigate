//
//  HomeFriendCell.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

protocol HomeFriendCellDelegate: AnyObject {
    func didTapFriendAvatar(author: Author)
}

final class HomeFriendCell: UICollectionViewCell {

    weak var delegate: HomeFriendCellDelegate?
    private var author: Author?
    private lazy var avatar = CircularImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setSubviews()
        setGesture()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatar)
    }

    func configure(author: Author) {
        self.author = author
        avatar.image = UIImage(named: author.avatar ?? "")
    }

    // MARK: - Actions
    @objc
    private func didTapAvatar() {
        guard let author = author else { return }
        delegate?.didTapFriendAvatar(author: author)
    }
}

// MARK: - GestureRecognizer
extension HomeFriendCell {
    private func setGesture() {
        let tapAvatarGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatar.addGestureRecognizer(tapAvatarGesture)
        avatar.isUserInteractionEnabled = true
    }
}

// MARK: - Set constraints
extension HomeFriendCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
