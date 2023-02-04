//
//  Typealiases.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

typealias HomeDiffableDataSource = UICollectionViewDiffableDataSource<HomeSection, HomeSection.Item>
typealias HomeDiffableSnapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSection.Item>

typealias FavoritesDiffableDataSource = UICollectionViewDiffableDataSource<FavoritesSection, FavoritesSection.Item>
typealias FavoritesDiffableSnapshot = NSDiffableDataSourceSnapshot<FavoritesSection, FavoritesSection.Item>
