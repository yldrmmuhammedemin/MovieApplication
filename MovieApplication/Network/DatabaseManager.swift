//
//  DatabaseManager.swift
//  MovieApplication
//
//  Created by Yildirim on 24.02.2023.
//

import Foundation
import Firebase
import Combine
import FirebaseFirestoreCombineSwift
import FirebaseFirestoreSwift


class DatabaseManager{
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let userPath = "users"
    let favoriteMoviesPath = "favorites"
    let watchlistPath = "watchlists"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error>{
        let appUser = AppUser(from: user)
        return db.collection(userPath).document(appUser.id).setData(from: appUser)
            .map{ _ in return true }
            .eraseToAnyPublisher()
    }
    
    func updateUsers(add user: AppUser, id: String) -> AnyPublisher<Bool, Error>{
        return db.collection(userPath).document(id).setData(from: user)
            .map{ _ in return true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retrieve id: String) -> AnyPublisher<AppUser, Error>{
        return db.collection(userPath).document(id).getDocument()
            .tryMap{ try $0.data(as: AppUser.self)}
            .eraseToAnyPublisher()
    }
        
    func collectionUsers(updateFields: [String:Any], for id: String) -> AnyPublisher<Bool, Error>{
        return db.collection(userPath).document(id).updateData(updateFields)
            .map {_ in return true}
            .eraseToAnyPublisher()
    }
    // MARK: - Favorite Movies
    
    func addCollectionFavorites(for id: String) -> AnyPublisher<Bool, Error>{
        let movie = FavoriteMovies(from: id)
        return db.collection(favoriteMoviesPath).document(id).setData(from: movie)
            .map{_ in return true}
            .eraseToAnyPublisher()
    }
    
    func addCollectionFavorites(add favoriteMovie: FavoriteMovies, for id: String) -> AnyPublisher<Bool, Error>{
        return db.collection(favoriteMoviesPath).document(id).setData(from: favoriteMovie)
            .map{_ in return true}
            .eraseToAnyPublisher()
    }
    
    func fetchCollectionFavorites(retrive id: String) -> AnyPublisher<FavoriteMovies, Error>{
        return db.collection(favoriteMoviesPath).document(id).getDocument()
            .tryMap{try $0.data(as: FavoriteMovies.self)}
            .eraseToAnyPublisher()
    }
    
    // MARK: - Watchlists Movies
    
    func addCollectionWatchlists(for id: String) -> AnyPublisher<Bool, Error>{
        let watch = Watchlists(from: id)
        return db.collection(watchlistPath).document(id).setData(from: watch)
            .map{_ in return true}
            .eraseToAnyPublisher()
    }
    
    func addCollectionWatchlists(add watchlist : Watchlists, for id: String) -> AnyPublisher<Bool, Error>{
        return db.collection(watchlistPath).document(id).setData(from: watchlist)
            .map{_ in return true}
            .eraseToAnyPublisher()
    }
    
    func fetchCollectionWatchlists(retrive id: String) -> AnyPublisher<Watchlists, Error>{
        return db.collection(watchlistPath).document(id).getDocument()
            .tryMap{try $0.data(as: Watchlists.self)}
            .eraseToAnyPublisher()
    }
}
