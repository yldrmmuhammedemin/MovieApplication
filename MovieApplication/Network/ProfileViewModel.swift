//
//  ProfileViewModel.swift
//  MovieApplication
//
//  Created by Yildirim on 27.02.2023.
//

import Foundation
import Combine
import Firebase

class ProfileViewModel: ObservableObject{
    
    @Published var user: AppUser?
    @Published var error: String?
    @Published var watchlist: Watchlists?
    private var id: String?
    private var subscriptions : Set<AnyCancellable> = []
    private var watchlistModels: [TitlePreviewViewModel]?
    
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
    
    func getWatchlistMovie(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.fetchCollectionWatchlists(retrive: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] watchlist in
                self?.watchlist = watchlist
            }.store(in: &subscriptions)
    }
}
