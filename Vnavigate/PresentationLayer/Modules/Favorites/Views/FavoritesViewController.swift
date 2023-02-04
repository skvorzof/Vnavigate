//
//  FavoritesViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 05.02.2023.
//

import UIKit

class FavoritesViewController: UIViewController {

    private let coordinator: FavoritesCoordinator
    private let viewModel: FavoritesViewModel
    private var dataSource: FavoritesDiffableDataSource?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        return activityIndicator
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: FavoritesCompositionLayout { [weak self] in
                self?.viewModel.dataSourceSnapshot.sectionIdentifiers[$0].layoutType ?? .postsLayout
            })
        return collectionView
    }()

    init(coordinator: FavoritesCoordinator, viewModel: FavoritesViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureColletionView()
        configureVewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.changeState(.initial)
        collectionView.reloadData()
    }

    // MARK: - configureVewModel
    private func configureVewModel() {
        viewModel.updateState = { [weak self] state in
            guard let self = self else { return }

            switch state {
            case .initial:
                break
            case .loading:
                self.activityIndicator.startAnimating()
            case .loaded:
                self.activityIndicator.stopAnimating()
                self.dataSource?.apply(self.viewModel.dataSourceSnapshot)
            case .error(let error):
                self.showAlert(with: "Ошибка", and: error)
            }
        }
    }

    // MARK: - configureColletionView
    private func configureColletionView() {
        view.addSubview(collectionView)

        let favoritesCellRegistration = UICollectionView.CellRegistration<FavoritesCell, Post> { cell, indexPath, post in
            cell.configure(post: post)
            cell.delegate = self
        }

        dataSource = FavoritesDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, section in
            switch section {
            case .postsItem(let post):
                return collectionView.dequeueConfiguredReusableCell(using: favoritesCellRegistration, for: indexPath, item: post)
            }
        }
    }
}

// MARK: - FavoritesCellDelegate
extension FavoritesViewController: FavoritesCellDelegate {
    func didTapArticle(post: Post) {
        coordinator.coordinateToFavoritesDetails(post: post)
    }

    func didTapIsLike(post: Post) {
        let isLike = post.isLike ? false : true
        post.setValue(isLike, forKey: "isLike")
        CoreDataManager.shared.save()
        collectionView.reloadData()
    }

    func didTapIsFavorite(post: Post) {
        let isFavorite = post.isFavorite ? false : true
        post.setValue(isFavorite, forKey: "isFavorite")
        CoreDataManager.shared.save()
        viewModel.changeState(.initial)
    }
}
