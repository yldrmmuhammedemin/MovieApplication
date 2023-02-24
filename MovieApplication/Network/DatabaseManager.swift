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
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error>{
        let appUser = AppUser(from: user)
        return db.collection(userPath).document(appUser.id).setData(from: appUser)
            .map{ _ in return true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retrieve id: String) -> AnyPublisher<AppUser, Error>{
        db.collection(userPath).document(id).getDocument()
            .tryMap{ try $0.data(as: AppUser.self)}
            .eraseToAnyPublisher()
    }
}
