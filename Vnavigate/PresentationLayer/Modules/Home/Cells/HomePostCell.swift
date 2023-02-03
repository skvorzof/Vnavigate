//
//  HomePostCell.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

protocol HomePostCellDelegate: AnyObject {
    func didTapArticle(post: Post)
    func didTapIsLike(post: Post)
    func didTapIsFavorite(post: Post)
}

final class HomePostCell: UICollectionViewCell {

    weak var delegate: HomePostCellDelegate?

    private var post: Post?

    private let avatar = CircularImageView()
    private let name = UILabel()
    private let profession = UILabel()
    private let thumbnail = UIImageView()

    private let article: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let isLike = UIImageView()
    private let isFavorite = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setSubviews(avatar, name, profession, thumbnail, article, isLike, isFavorite)
        setUI()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(post: Post) {
        self.post = post
        avatar.image = UIImage(named: post.author?.avatar ?? "")
        name.text = post.author?.name
        profession.text = post.author?.profession
        thumbnail.image = UIImage(named: post.thumbnail ?? "")
        article.text = post.article?.limitedText(to: 120)

        if post.isLike {
            isLike.image = UIImage(systemName: "heart.fill")
        } else {
            isLike.image = UIImage(systemName: "heart")
        }

        if post.isFavorites {
            isFavorite.image = UIImage(systemName: "bookmark.fill")
        } else {
            isFavorite.image = UIImage(systemName: "bookmark")
        }
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }

    private func setUI() {
        let tapArticleGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArticle))
        article.addGestureRecognizer(tapArticleGesture)
        article.isUserInteractionEnabled = true

        let tapIsLikeGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsLike))
        isLike.addGestureRecognizer(tapIsLikeGesture)
        isLike.isUserInteractionEnabled = true

        let tapIsFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsFavorite))
        isFavorite.addGestureRecognizer(tapIsFavoriteGesture)
        isFavorite.isUserInteractionEnabled = true
    }

    @objc
    private func didTapArticle() {
        guard let post = post else { return }
        delegate?.didTapArticle(post: post)
    }

    @objc
    private func didTapIsLike() {
        guard let post = post else { return }
        delegate?.didTapIsLike(post: post)
    }

    @objc
    private func didTapIsFavorite() {
        guard let post = post else { return }
        delegate?.didTapIsFavorite(post: post)
    }

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

            thumbnail.heightAnchor.constraint(equalToConstant: 200),
            thumbnail.topAnchor.constraint(equalTo: profession.bottomAnchor, constant: 20),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor),

            article.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 10),
            article.leadingAnchor.constraint(equalTo: leadingAnchor),
            article.trailingAnchor.constraint(equalTo: trailingAnchor),

            isLike.widthAnchor.constraint(equalToConstant: 28),
            isLike.heightAnchor.constraint(equalToConstant: 28),
            isLike.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 7),
            isLike.leadingAnchor.constraint(equalTo: leadingAnchor),

            isFavorite.widthAnchor.constraint(equalToConstant: 25),
            isFavorite.heightAnchor.constraint(equalToConstant: 25),
            isFavorite.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 10),
            isFavorite.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
