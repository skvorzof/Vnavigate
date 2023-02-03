//
//  HomeSection.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

struct HomeSection: Hashable {
    
    enum `Type`: Hashable {
        case friends
        case posts
    }
    
    enum Item: Hashable {
        case friendsItem(Author)
        case postsItem(Post)
    }
    
    enum LayoutType {
        case friendsLayout
        case postsLayout
    }
    
    let type: Type
    
    static let friends = Self(type: .friends)
    static let posts = Self(type: .posts)
    
    var layoutType: LayoutType {
        switch type {
        case .friends:
            return .friendsLayout
        case .posts:
            return .postsLayout
        }
    }
    
    init(type: Type) {
        self.type = type
    }
}

// MARK: - Разметка для секций HomeSection
extension HomeSection.LayoutType {
    
    func section(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch self {
        case .friendsLayout:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .estimated(60), heightDimension: .estimated(60)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            return section
            
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
