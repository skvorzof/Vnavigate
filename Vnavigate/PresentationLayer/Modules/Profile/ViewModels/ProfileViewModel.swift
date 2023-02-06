//
//  ProfileViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import Foundation
import UIKit

final class ProfileViewModel {

    var dataSourceSnapshot = ProfileDiffableSnapshot()

    var updateState: ((State) -> Void)?
    
    var defaultAuthor: Author?

    private(set) var state: State = .initial {
        didSet {
            updateState?(state)
        }
    }

    func changeState(_ action: Action) {
        switch action {
        case .initial:
            state = .loading

            guard let fetchauthor = CoreDataManager.shared.fetchAuthor(authorId: defaultAuthor?.authorId ?? "0") else { return }

            dataSourceSnapshot = makeSnaphot(author: fetchauthor)

            state = .loaded
        }
    }

    private func makeSnaphot(author: Author) -> ProfileDiffableSnapshot {

        var snapshot = ProfileDiffableSnapshot()

        snapshot.appendSections([.info])
        snapshot.appendItems([.infoItem(author)], toSection: .info)

        if let photos = author.photos?.allObjects as? [Photo] {
            snapshot.appendSections([.photos])
            snapshot.appendItems(
                photos.map {
                    ProfileSection.Item.photosItem($0)
                }, toSection: .photos)
        }

        if let posts = author.posts?.allObjects as? [Post] {
            snapshot.appendSections([.posts])
            snapshot.appendItems(
                posts.map {
                    ProfileSection.Item.postsItem($0)
                }, toSection: .posts)
        }

        return snapshot
    }
}
