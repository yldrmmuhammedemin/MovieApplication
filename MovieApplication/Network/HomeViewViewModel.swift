//
//  HomeViewViewModel.swift
//  MovieApplication
//
//  Created by Yildirim on 24.02.2023.
//

import Foundation
import Combine
import FirebaseAuth

class HomeViewViewModel: ObservableObject{
    @Published var user: AppUser?
    @Published var error: String?
    
    private var subscriptions : Set<AnyCancellable> = []
    
    func retriveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.error = error.localizedDescription
                        }
                    } receiveValue: { [weak self] user in
                        self?.user = user
                    }
                    .store(in: &subscriptions)
    }
}
