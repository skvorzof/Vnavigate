//
//  PreloadData.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import CoreData
import Foundation

final class PreloadData {

    static let shared = PreloadData()
    private init() {}

    struct JSONAuthor: Decodable {
        let name: String
        let avatar: String
        let profession: String
        let isFriend: Bool
        let photos: [JSONPhoto]
        let posts: [JSONPost]
    }

    struct JSONPhoto: Decodable {
        let image: String
    }

    struct JSONPost: Decodable {
        let thumbnail: String
        let article: String
        let isLike: Bool
        let isFavorite: Bool
    }

    func preloadData() {
        do {
            guard let pathData = Bundle.main.path(forResource: "preload", ofType: "json"),
                let jsonData = try String(contentsOfFile: pathData).data(using: .utf8)
            else { return }

            guard let decodetedData = try? JSONDecoder().decode([JSONAuthor].self, from: jsonData) else { return }

            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext

            decodetedData.forEach { jsonAuthor in
                let author = Author(context: privateContext)
                author.avatar = jsonAuthor.avatar
                author.name = jsonAuthor.name
                author.profession = jsonAuthor.profession
                author.isFriend = jsonAuthor.isFriend

                jsonAuthor.photos.forEach { jsonPhoto in
                    let photo = Photo(context: privateContext)
                    photo.image = jsonPhoto.image
                    photo.author = author
                }

                jsonAuthor.posts.forEach { jsonPost in
                    let post = Post(context: privateContext)
                    post.thumbnail = jsonPost.thumbnail
                    post.article = jsonPost.article
                    post.isLike = jsonPost.isLike
                    post.isFavorite = jsonPost.isFavorite
                    post.author = author
                }

                if privateContext.hasChanges {
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let error {
                        print("Ошибка сохранения в базу preloadData", error.localizedDescription)
                    }
                }
            }
        } catch let error {
            print("Ошибка сохранения в базу preloadData", error.localizedDescription)
        }
    }
}
