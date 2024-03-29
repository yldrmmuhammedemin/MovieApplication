//
//  AuthenticationViewViewModel.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//
import Foundation
import Combine
import Firebase

final class AuthenticationViewViewModel : ObservableObject {
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    private var id : String?
    
    private var subscriptions: Set<AnyCancellable> = []
        
    func validateAuthenticationForm(){
        guard let email = email,
              let password = password else {
            isAuthenticationFormValid = false
            return
        }
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser(){
        guard let email = email,
              let password = password else{return}
        AuthManager.shared.createUser(with: email, password: password).handleEvents(receiveOutput: { [weak self] user in
            self?.user = user
        })
        .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
                self?.id = user.uid
                self?.createFavoriteMovieRecord(for: (self?.id)!)
                self?.createWatchlistRecord(for: (self?.id)!)
            }.store(in: &subscriptions)
    }
    
    func createFavoriteMovieRecord(for userId: String){
        DatabaseManager.shared.addCollectionFavorites(for: userId).sink { [weak self] completion in
            if case .failure(let error) = completion{
                self?.error = error.localizedDescription
                print(error)
            }
        } receiveValue: { state in
            print("Favorite Movie Collection has been added. : \(state)")
        }.store(in: &subscriptions)

    }
    
    func createWatchlistRecord(for userId: String){
        DatabaseManager.shared.addCollectionWatchlists(for: userId).sink { [weak self] completion in
            if case .failure(let error) = completion{
                self?.error = error.localizedDescription
                print(error)
            }
        } receiveValue: { state in
            print("Watchlist collection has been added. : \(state)")
        }.store(in: &subscriptions)

    }
    
    func createRecord(for user: User){
        DatabaseManager.shared.collectionUsers(add: user).sink { [weak self] completion in
            if case .failure(let error) = completion{
                self?.error = error.localizedDescription
            }
        } receiveValue: { state in
            print("User has been added to database: \(state)")
        }.store(in: &subscriptions)
    }
    
    func loginUser(){
        guard let email = email,
              let password = password else {return}
        AuthManager.shared.loginUser(with: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)
    }
}

