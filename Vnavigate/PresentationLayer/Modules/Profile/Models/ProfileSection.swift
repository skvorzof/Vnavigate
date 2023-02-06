//
//  ProfileSection.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

import UIKit

struct ProfileSection: Hashable {
    
    enum `Type`: Hashable {
        case info
        case photos
        case posts
    }
    
    enum Item: Hashable {
        case infoItem(Author)
        case photosItem(Photo)
        case postsItem(Post)
    }
    
    enum LayoutType {
        case infoLayout
        case photosLayout
        case postsLayout
    }
    
    let type: Type
    
    static let info = Self(type: .info)
    static let photos = Self(type: .photos)
    static let posts = Self(type: .posts)
    
    var layoutType: LayoutType {
        switch type {
        case .info:
            return .infoLayout
        case .photos:
            return .photosLayout
        case .posts:
            return .postsLayout
        }
    }
    
    init(type: Type) {
        self.type = type
    }
}

extension ProfileSection.LayoutType {
    
    func section(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch self {
        case .infoLayout:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(340)))
            item.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
            return section
            
        case .photosLayout:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(70)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            return section
            
        case .postsLayout:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(350)))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 20, leading: 16, bottom: 0, trailing: 16)
            return section
        }
    }
}
