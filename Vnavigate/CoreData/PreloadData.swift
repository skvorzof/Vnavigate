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
        let like: String
        let isFavorites: Bool
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
            }
        } catch {

        }
    }

}
