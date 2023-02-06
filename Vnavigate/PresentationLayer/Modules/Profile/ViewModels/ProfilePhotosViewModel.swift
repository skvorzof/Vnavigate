//
//  ProfilePhotosViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

final class ProfilePhotosViewModel {

    let author: Author
    var photos: [Photo] = []
    

    var updateState: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            updateState?(state)
        }
    }
    
    init(author: Author) {
        self.author = author
    }

    func changeState(_ action: Action) {
        switch action {
        case .initial:
            state = .loading

            guard let photos = CoreDataManager.shared.fetchPhotosToAuthor(author: author) else { return }
            self.photos = photos

            

            state = .loaded
        }
    }
}
