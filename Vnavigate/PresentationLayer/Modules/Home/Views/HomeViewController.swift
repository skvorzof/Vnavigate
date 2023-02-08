//
//  HomeViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let coordinator: HomeCoordinator
    private let viewModel: HomeViewModel
    private var dataSource: HomeDiffableDataSource?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        return activityIndicator
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: HomeCompositionalLayout { [weak self] in
                self?.viewModel.dataSourceSnapshot.sectionIdentifiers[$0].layoutType ?? .friendsLayout
            })
        return collectionView
    }()

    init(coordinator: HomeCoordinator, viewModel: HomeViewModel) {
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

        configureColletionView()
        configureViewModel()
        viewModel.changeState(.initial)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.changeState(.initial)
        collectionView.reloadData()
    }

    private func configureViewModel() {
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
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)

        let homeFriendCellRegistration = UICollectionView.CellRegistration<HomeFriendCell, Author> { cell, indexPath, author in
            cell.configure(author: author)
            cell.delegate = self
        }

        let homePostCellRegistration = UICollectionView.CellRegistration<HomePostCell, Post> { cell, indexPath, post in
            cell.configure(post: post)
            cell.delegate = self
        }

        dataSource = HomeDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, section in

            switch section {
            case .friendsItem(let author):
                return collectionView.dequeueConfiguredReusableCell(using: homeFriendCellRegistration, for: indexPath, item: author)

            case .postsItem(let post):
                return collectionView.dequeueConfiguredReusableCell(using: homePostCellRegistration, for: indexPath, item: post)
            }
        }
    }
}

// MARK: - HomeFriendCellDelegate
extension HomeViewController: HomeFriendCellDelegate {
    func didTapFriendAvatar(author: Author) {
        coordinator.coordinateToHomeAuthorProfile(author: author)
    }
}

// MARK: - HomePostCellDelegate
extension HomeViewController: HomePostCellDelegate {
    func didTapAvatar(author: Author) {
        coordinator.coordinateToHomeAuthorProfile(author: author)
    }

    func didTapArticle(post: Post) {
        coordinator.coordinateToHomePostDetail(post: post)
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
        collectionView.reloadData()
    }
}
