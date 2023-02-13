//
//  ProfilePhotosViewModel.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 06.02.2023.
//

final class ProfilePhotosViewModel {

    let author: Author
    var photos: [Photo] = []

    init(author: Author) {
        self.author = author
    }

    func fetch() {
        photos = CoreDataManager.shared.fetchWithAuthor(Photo.self, author: author, sortDescriptors: nil)
    }
}
