//
//  FavoritesSection.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 05.02.2023.
//

import UIKit

struct FavoritesSection: Hashable {

    enum `Type`: Hashable {
        case posts
    }

    enum Item: Hashable {
        case postsItem(Post)
    }

    enum LayoutType {
        case postsLayout
    }

    let type: Type

    static let posts = Self(type: .posts)

    var layoutType: LayoutType {
        switch type {
        case .posts:
            return .postsLayout
        }
    }

    init(type: Type) {
        self.type = type
    }
}

extension FavoritesSection.LayoutType {
    func section(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch self {
        case .postsLayout:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(420)))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 20, leading: 16, bottom: 0, trailing: 16)
            return section
        }
    }
}
