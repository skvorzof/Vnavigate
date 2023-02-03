//
//  HomeViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import Foundation

final class HomeViewModel {

    var dataSourceSnapshot = HomeDiffableSnapshot()
    var authors: [Author] = []
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

            authors = CoreDataManager.shared.fetchFriends()
            posts = CoreDataManager.shared.fetchAllPosts()
            
            dataSourceSnapshot = makeSnaphot(authors: authors, posts: posts)
            
            state = .loaded
        }
    }
    
    private func makeSnaphot(authors: [Author], posts: [Post]) -> HomeDiffableSnapshot {
        var snapshot = HomeDiffableSnapshot()
        
        snapshot.appendSections([.friends])
        snapshot.appendItems(authors.map {
            HomeSection.Item.friendsItem($0)
        }, toSection: .friends)
        
        snapshot.appendSections([.posts])
        snapshot.appendItems(posts.map{
            HomeSection.Item.postsItem($0)
        }, toSection: .posts)
        
        return snapshot
    }
}
