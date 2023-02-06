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

    func fetchFriends() -> [Author] {
        let request: NSFetchRequest<Author> = Author.fetchRequest()
        request.predicate = NSPredicate(format: "isFriend = %d", true)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetched author posts \(error)")
            return []
        }
    }

    func fetchPostsToAuthor(author: Author) -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@", author)
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        var fetchedPosts: [Post] = []

        do {
            fetchedPosts = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetched author posts \(error)")
        }
        return fetchedPosts
    }

    func fetchPhotosToAuthor(author: Author) -> [Photo]? {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@", author)
        request.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]

        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetched author posts \(error)")
            return nil
        }
    }

    func fetchFavoritesPost() -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite = %d", true)
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        var fetchedPosts: [Post] = []

        do {
            fetchedPosts = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetched author posts \(error)")
        }
        return fetchedPosts
    }

    func fetchAllPosts() -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        var fetchedPosts: [Post] = []

        do {
            fetchedPosts = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetched posts \(error)")
        }
        return fetchedPosts
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
