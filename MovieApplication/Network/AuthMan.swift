//
//  AuthMan.swift
//  Application
//
//  Created by Yildirim on 14.02.2023.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift

class AuthMan{
    static let shared = AuthMan()
    
    func createUser(with email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password){
            
        }
    }
    
    func loginUser(with email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    
}
