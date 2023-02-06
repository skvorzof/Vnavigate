//
//  ProfilePhotoDeatilCell.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import UIKit

class ProfilePhotoDeatilCell: UICollectionViewCell {

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
        setConstraints()
    }

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

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor),
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
