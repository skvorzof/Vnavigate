//
//  FavoritesViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 05.02.2023.
//

import UIKit

final class FavoritesViewController: UIViewController {

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
            frame: .zero,
            collectionViewLayout: FavoritesCompositionLayout { [weak self] in
                self?.viewModel.dataSourceSnapshot.sectionIdentifiers[$0].layoutType ?? .postsLayout
            })
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(coordinator: FavoritesCoordinator, viewModel: FavoritesViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureColletionView()
        setConstraints()
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
            cell.indexPath = indexPath
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

    func didTapIsLike(post: Post, indexPath: IndexPath) {
        let isLike = !post.isLike
        post.setValue(isLike, forKey: "isLike")
        CoreDataManager.shared.save()

        guard let selectedLike = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reconfigureItems([selectedLike])
        dataSource?.apply(snapshot)
    }

    func didTapIsFavorite(post: Post) {
        let isFavorite = !post.isFavorite
        post.setValue(isFavorite, forKey: "isFavorite")
        CoreDataManager.shared.save()
        viewModel.changeState(.initial)
    }
}

// MARK: - setConstraints
extension FavoritesViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
