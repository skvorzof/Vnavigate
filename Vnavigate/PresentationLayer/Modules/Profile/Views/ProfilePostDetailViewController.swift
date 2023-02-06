//
//  ProfilePostDetailViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import UIKit

class ProfilePostDetailViewController: UIViewController {

    private let viewModel: ProfilePostDetailViewModel

    private let thumbnail = UIImageView()

    private let article: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let likeIcon = UIImageView()
    private let favoriteIcon = UIImageView()

    init(viewModel: ProfilePostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setSubviews(thumbnail, article, likeIcon, likeIcon, favoriteIcon)
        setUI()
        setGesture()
        setConstraints()
    }

    private func setUI() {
        thumbnail.image = UIImage(named: viewModel.post.thumbnail ?? "")
        article.text = viewModel.post.article

        let likeImage = viewModel.post.isLike ? "heart.fill" : "heart"
        likeIcon.image = UIImage(systemName: likeImage)

        let favoriteImage = viewModel.post.isFavorite ? "bookmark.fill" : "bookmark"
        favoriteIcon.image = UIImage(systemName: favoriteImage)
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }
    
    private func setGesture() {
        let tapIsLikeGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsLike))
        likeIcon.addGestureRecognizer(tapIsLikeGesture)
        likeIcon.isUserInteractionEnabled = true

        let tapIsFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsFavorite))
        favoriteIcon.addGestureRecognizer(tapIsFavoriteGesture)
        favoriteIcon.isUserInteractionEnabled = true
    }

    @objc
    private func didTapIsLike() {
        let like = viewModel.post.isLike ? false : true
        viewModel.post.setValue(like, forKey: "isLike")
        CoreDataManager.shared.save()
        
        let likeImage = viewModel.post.isLike ? "heart.fill" : "heart"
        likeIcon.image = UIImage(systemName: likeImage)
    }

    @objc
    private func didTapIsFavorite() {
        let favorite = viewModel.post.isFavorite ? false : true
        viewModel.post.setValue(favorite, forKey: "isFavorite")
        CoreDataManager.shared.save()
        
        let favoriteImage = viewModel.post.isFavorite ? "bookmark.fill" : "bookmark"
        favoriteIcon.image = UIImage(systemName: favoriteImage)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnail.heightAnchor.constraint(equalToConstant: 200),
            thumbnail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            thumbnail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thumbnail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            article.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 10),
            article.leadingAnchor.constraint(equalTo: thumbnail.leadingAnchor),
            article.trailingAnchor.constraint(equalTo: thumbnail.trailingAnchor),

            likeIcon.widthAnchor.constraint(equalToConstant: 28),
            likeIcon.heightAnchor.constraint(equalToConstant: 28),
            likeIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 7),
            likeIcon.leadingAnchor.constraint(equalTo: thumbnail.leadingAnchor),

            favoriteIcon.widthAnchor.constraint(equalToConstant: 25),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 25),
            favoriteIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 10),
            favoriteIcon.trailingAnchor.constraint(equalTo: thumbnail.trailingAnchor),
        ])
    }
}
