//
//  FavoritesViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 05.02.2023.
//

import Foundation

final class FavoritesViewModel {

    weak var view: FavoritesViewController?
    var dataSourceSnapshot = FavoritesDiffableSnapshot()

    func fetch() {
        let favoritePredicate = NSPredicate(format: "isFavorite = %d", true)
        let favoriteSort = NSSortDescriptor(key: "publishedAt", ascending: false)
        let posts = CoreDataManager.shared.fetch(Post.self, predicate: favoritePredicate, sortDescriptors: favoriteSort)

        dataSourceSnapshot = makeSnaphot(posts: posts)

        view?.changeState(.loaded)
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
