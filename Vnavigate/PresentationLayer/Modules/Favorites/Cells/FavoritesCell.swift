//
//  FavoritesCell.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 05.02.2023.
//

import UIKit

protocol FavoritesCellDelegate: AnyObject {
    func didTapArticle(post: Post)
    func didTapIsLike(post: Post)
    func didTapIsFavorite(post: Post)
}

final class FavoritesCell: UICollectionViewCell {

    weak var delegate: FavoritesCellDelegate?

    private var post: Post?

    private lazy var avatar = CircularImageView()
    private lazy var name = UILabel()

    private lazy var profession: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray
        return label
    }()

    private lazy var thumbnail = UIImageView()

    private lazy var article: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var likeIcon = UIImageView()
    private lazy var favoriteIcon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setSubviews(avatar, name, profession, thumbnail, article, likeIcon, favoriteIcon)
        setUI()
        setGesture()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        likeIcon.image = nil
        favoriteIcon.image = nil
    }

    func configure(post: Post) {
        self.post = post
        avatar.image = UIImage(named: post.author?.avatar ?? "")
        name.text = post.author?.name
        profession.text = post.author?.profession
        thumbnail.image = UIImage(named: post.thumbnail ?? "")
        article.text = post.article?.limitedText(to: 120)

        let likeImage = post.isLike ? "heart.fill" : "heart"
        likeIcon.image = UIImage(systemName: likeImage)

        let favoriteImage = post.isFavorite ? "bookmark.fill" : "bookmark"
        favoriteIcon.image = UIImage(systemName: favoriteImage)
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }

    private func setUI() {
        backgroundColor = .systemBackground
    }

    // MARK: - Actions
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

}

// MARK: - GestureRecognizer
extension FavoritesCell {
    private func setGesture() {
        let tapThumbnailGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArticle))
        thumbnail.addGestureRecognizer(tapThumbnailGesture)
        thumbnail.isUserInteractionEnabled = true

        let tapArticleGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArticle))
        article.addGestureRecognizer(tapArticleGesture)
        article.isUserInteractionEnabled = true

        let tapIsLikeGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsLike))
        likeIcon.addGestureRecognizer(tapIsLikeGesture)
        likeIcon.isUserInteractionEnabled = true

        let tapIsFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsFavorite))
        favoriteIcon.addGestureRecognizer(tapIsFavoriteGesture)
        favoriteIcon.isUserInteractionEnabled = true
    }
}

// MARK: - Set constraints
extension FavoritesCell {
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

            likeIcon.widthAnchor.constraint(equalToConstant: 28),
            likeIcon.heightAnchor.constraint(equalToConstant: 28),
            likeIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 7),
            likeIcon.leadingAnchor.constraint(equalTo: leadingAnchor),

            favoriteIcon.widthAnchor.constraint(equalToConstant: 25),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 25),
            favoriteIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 10),
            favoriteIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
