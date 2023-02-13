//
//  ProfilePhotoCell.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import UIKit

protocol ProfilePhotoCellDelegate: AnyObject {
    func didTapPhoto(author: Author)
}

final class ProfilePhotoCell: UICollectionViewCell {

    weak var delegate: ProfilePhotoCellDelegate?
    var author: Author?

    private lazy var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

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

    func configure(photo: Photo) {
        author = photo.author
        self.photo.image = UIImage(named: photo.image ?? "")

    }

    private func setSubviews() {
        photo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photo)
    }

    // MARK: - Actions
    @objc
    private func didTapPhoto() {
        guard let author = author else { return }
        delegate?.didTapPhoto(author: author)
    }
}

// MARK: - GestureRecognizer
extension ProfilePhotoCell {
    private func setGesture() {
        let tapPhotoGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        photo.addGestureRecognizer(tapPhotoGesture)
        photo.isUserInteractionEnabled = true
    }
}

// MARK: - setConstraints
extension ProfilePhotoCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            photo.widthAnchor.constraint(equalToConstant: 70),
            photo.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
}
