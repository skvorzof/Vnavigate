//
//  HomeViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import Foundation
import UIKit

final class HomeViewModel {

    var view: HomeViewController?
    var dataSourceSnapshot = HomeDiffableSnapshot()

    func fethc() {
        let friendsPredicate = NSPredicate(format: "isFriend = %d", true)
        let authors = CoreDataManager.shared.fetch(Author.self, predicate: friendsPredicate, sortDescriptors: nil)

        let postsSort = NSSortDescriptor(key: "publishedAt", ascending: false)
        let posts = CoreDataManager.shared.fetch(Post.self, predicate: nil, sortDescriptors: postsSort)

        dataSourceSnapshot = makeSnaphot(authors: authors, posts: posts)

        view?.changeState(.loaded)
    }

    private func makeSnaphot(authors: [Author], posts: [Post]) -> HomeDiffableSnapshot {
        var snapshot = HomeDiffableSnapshot()

        snapshot.appendSections([.friends])
        snapshot.appendItems(
            authors.map {
                HomeSection.Item.friendsItem($0)
            }, toSection: .friends)

        snapshot.appendSections([.posts])
        snapshot.appendItems(
            posts.map {
                HomeSection.Item.postsItem($0)
            }, toSection: .posts)

        return snapshot
    }
}
