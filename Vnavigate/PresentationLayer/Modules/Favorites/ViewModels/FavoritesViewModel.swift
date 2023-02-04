//
//  FavoritesViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 05.02.2023.
//

import Foundation

final class FavoritesViewModel {

    var dataSourceSnapshot = FavoritesDiffableSnapshot()
    var posts: [Post] = []

    var updateState: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            updateState?(state)
        }
    }

    func changeState(_ action: Action) {
        switch action {
        case .initial:
            state = .loading

            posts = CoreDataManager.shared.fetchFavoritesPost()

            dataSourceSnapshot = makeSnaphot(posts: posts)

            state = .loaded
        }
    }

    private func makeSnaphot(posts: [Post]) -> FavoritesDiffableSnapshot {
        var snapshot = FavoritesDiffableSnapshot()

        snapshot.appendSections([.posts])
        snapshot.appendItems(
            posts.map {
                FavoritesSection.Item.postsItem($0)
            }, toSection: .posts)

        return snapshot
    }
}
