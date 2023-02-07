//
//  CoreDataManager.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolver error \(error)")
            }
        }
        return container
    }()

    func saveAuthor(name: String) -> Author {
        let author = Author(context: persistentContainer.viewContext)
        author.name = name
        return author
    }

    func savePost(article: Post, author: Author) -> Post {
        var post = Post(context: persistentContainer.viewContext)
        post = article
        author.addToPosts(post)
        return post
    }

    // MARK: - fetch
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sortDescriptors: NSSortDescriptor?) -> [T] {
        guard let model = model as? NSManagedObject.Type else { return [] }
        let context = persistentContainer.viewContext

        let request = model.fetchRequest()
        request.predicate = predicate

        if let sortDescriptors {
            request.sortDescriptors = [sortDescriptors]
        }

        guard let fetchRequestResult = try? context.fetch(request),
            let fetchedObjects = fetchRequestResult as? [T]
        else { return [] }
        return fetchedObjects
    }

    // MARK: - fetchWithAuthor
    func fetchWithAuthor<T>(_ model: T.Type, author: Author, sortDescriptors: NSSortDescriptor?) -> [T] {
        guard let model = model as? NSManagedObject.Type else { return [] }
        let context = persistentContainer.viewContext

        let request = model.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@", author)

        if let sortDescriptors {
            request.sortDescriptors = [sortDescriptors]
        }

        guard let fetchRequestResult = try? context.fetch(request),
            let fetchedObjects = fetchRequestResult as? [T]
        else { return [] }
        return fetchedObjects
    }

    // MARK: - fetchAuthor
    func fetchAuthor(authorId: String) -> Author? {
        let request: NSFetchRequest<Author> = Author.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "authorId = %@", authorId)

        do {
            return try persistentContainer.viewContext.fetch(request).first
        } catch let error {
            print("Error feched authors \(error)")
            return nil
        }
    }

    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror)")
            }
        }
    }
}
