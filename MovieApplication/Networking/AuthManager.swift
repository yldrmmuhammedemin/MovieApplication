//
//  Authentication.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift

class AuthManager{
    static let shared = AuthManager()
    
    func createUser(with email: String, password: String) -> AnyPublisher <User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func loginUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    
}
