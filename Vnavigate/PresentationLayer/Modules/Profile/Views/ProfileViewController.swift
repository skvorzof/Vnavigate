//
//  ProfileViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import FirebaseAuth
import UIKit

final class ProfileViewController: UIViewController {

    private let coordinator: ProfileCoordinator
    private let viewModel: ProfileViewModel
    private var dataSource: ProfileDiffableDataSource?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        return activityIndicator
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: ProfileCompositionalLayout { [weak self] in
                self?.viewModel.dataSourceSnapshot.sectionIdentifiers[$0].layoutType ?? .infoLayout
            })
        return collectionView
    }()

    init(coordinator: ProfileCoordinator, viewModel: ProfileViewModel) {
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
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeState(.loading)
        collectionView.reloadData()
    }

    // MARK: - changeState
    func changeState(_ state: State) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            viewModel.fetch()
        case .loaded:
            activityIndicator.stopAnimating()
            dataSource?.apply(viewModel.dataSourceSnapshot)
        case .error(_):
            showAlert(with: "Ошибка", and: "Ошибка загрузки данных")
        }
    }

    // MARK: - configureColletionView
    private func configureColletionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        let profileInfoCellRegistration = UICollectionView.CellRegistration<ProfileInfoCell, Author> { cell, indexPath, author in
            cell.configure(author: author)
            cell.delegate = self
        }

        let profilePhotoCellRegistration = UICollectionView.CellRegistration<ProfilePhotoCell, Photo> { cell, indexPath, photo in
            cell.configure(photo: photo)
            cell.delegate = self
        }

        let profilePostCellRegistration = UICollectionView.CellRegistration<ProfilePostCell, Post> { cell, indexPath, post in
            cell.configure(post: post)
            cell.delegate = self
            cell.indexPath = indexPath
        }

        dataSource = ProfileDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, section in

            switch section {
            case .infoItem(let author):
                return collectionView.dequeueConfiguredReusableCell(using: profileInfoCellRegistration, for: indexPath, item: author)

            case .photosItem(let photo):
                return collectionView.dequeueConfiguredReusableCell(using: profilePhotoCellRegistration, for: indexPath, item: photo)

            case .postsItem(let post):
                return collectionView.dequeueConfiguredReusableCell(using: profilePostCellRegistration, for: indexPath, item: post)
            }
        }
    }
}

// MARK: - ProfileInfoCellDelegate
extension ProfileViewController: ProfileInfoCellDelegate {
    func didTapOutButton() {
        do {
            try Auth.auth().signOut()
            coordinator.coordinateToSignOut()
        } catch let error {
            navigationController?.showAlert(with: "Ошибка", and: error.localizedDescription)
        }
    }

    func didTapPhotosButton(author: Author) {
        coordinator.coordinateToProfilePhotos(author: author)
    }
}

extension ProfileViewController: ProfilePhotoCellDelegate {
    func didTapPhoto(author: Author) {
        coordinator.coordinateToProfilePhotos(author: author)
    }
}

// MARK: - ProfilePostCellDelegate
extension ProfileViewController: ProfilePostCellDelegate {
    func didTapArticle(post: Post) {
        coordinator.coordinateToPostDetails(post: post)
    }

    func didTapIsLike(post: Post, indexPath: IndexPath) {
        let isLike = post.isLike ? false : true
        post.setValue(isLike, forKey: "isLike")
        CoreDataManager.shared.save()

        guard let selectedLike = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reconfigureItems([selectedLike])
        dataSource?.apply(snapshot)
    }

    func didTapIsFavorite(post: Post, indexPath: IndexPath) {
        let isFavorite = post.isFavorite ? false : true
        post.setValue(isFavorite, forKey: "isFavorite")
        CoreDataManager.shared.save()

        guard let selectedFavorite = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reconfigureItems([selectedFavorite])
        dataSource?.apply(snapshot)
    }
}

// MARK: - setConstraints
extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
