//
//  HomeViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import Foundation

final class HomeViewModel {

    var authors: [Author] = []

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

            authors = CoreDataManager.shared.fetchAuthors()

            authors.forEach { author in
                print(author.name)
            }
        }
    }
}
