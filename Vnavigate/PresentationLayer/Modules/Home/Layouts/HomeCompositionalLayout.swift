//
//  HomeCompositionalLayout.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class HomeCompositionalLayout: UICollectionViewCompositionalLayout {
    
    init(layoutTypeProvider: @escaping (Int) -> HomeSection.LayoutType) {
        super.init(sectionProvider: { index, environment in
            return layoutTypeProvider(index).section(environment: environment)
        }, configuration: {
            return UICollectionViewCompositionalLayoutConfiguration()
        }())
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
