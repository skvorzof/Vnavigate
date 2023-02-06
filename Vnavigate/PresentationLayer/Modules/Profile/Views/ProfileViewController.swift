//
//  ProfileViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

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
            frame: view.bounds,
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
        configureVewModel()
        viewModel.changeState(.initial)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    func didTapSettingsButton() {
        
    }
    
    func didTapPhotosButton(author: Author) {
        coordinator.coordinateToProfilePhotos(author: author)
    }
    
    func didTapsettingsButton() {
        
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
