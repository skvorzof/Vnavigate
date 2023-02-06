//
//  ProfilePhotosViewContoller.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import UIKit

class ProfilePhotosViewContoller: UIViewController {

    private let coordinator: ProfileCoordinator
    private let viewModel: ProfilePhotosViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()

    init(coordinator: ProfileCoordinator, viewModel: ProfilePhotosViewModel) {
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
        viewModel.changeState(.initial)
    }

    private func configureColletionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
//        collectionView.register(cellType: ProfilePhotoCell.self)
        collectionView.register(ProfilePhotoDeatilCell.self, forCellWithReuseIdentifier: "ProfilePhotoDeatilCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
            layout.scrollDirection = .vertical
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProfilePhotosViewContoller: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoDeatilCell", for: indexPath) as! ProfilePhotoDeatilCell
        let photo = viewModel.photos[indexPath.item]
        cell.configure(photo: photo)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfilePhotosViewContoller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.bounds.width - 8 * 4) / 3
            return CGSize(width: width, height: width)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            8
        }
}

// MARK: - UICollectionViewDelegate
extension ProfilePhotosViewContoller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.item]
        coordinator.coordinateToPhotosDetails(photo: photo)
    }
}
