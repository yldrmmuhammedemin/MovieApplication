//
//  FavoriteMoviesViewModel.swift
//  MovieApplication
//
//  Created by Yildirim on 28.02.2023.
//

import Foundation
import Firebase
import Combine

class FavoriteMoviesViewModel: ObservableObject{
    private var subscriptions: Set<AnyCancellable> = []
    @Published var user: AppUser?
    @Published var id: String?
    @Published var favoriteMovies: [TitlePreviewViewModel]?
    @Published var error: String?
    
    func retriveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.error = error.localizedDescription
                        }
                    } receiveValue: { [weak self] user in
                        self?.user = user
                        self?.favoriteMovies = user.favoriteMovies
                    }
                    .store(in: &subscriptions)
    }
    
    func updateFavoriteMovies(model: TitlePreviewViewModel){
        retriveUser()
        guard let id = self.user?.id else{return}
        if !self.favoriteMovies!.contains(model){
            self.favoriteMovies?.append(model)
            guard let favoriteMovies = self.favoriteMovies else {return}
            let updateFileds: [String:[TitlePreviewViewModel]] = ["favoriteMovies": favoriteMovies]
            DatabaseManager.shared.collectionAddFavorite(updateFields: updateFileds, for: id).sink { [weak self] completion in
                if case .failure(let error) = completion{
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }receiveValue: { [weak self] status in
                print("Movie has been successfully added : \(status)")
            }.store(in: &subscriptions)
        }else{
            print("This Movie Already Added Favorites.")
        }
        }

}
