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

    @Published var error: String?
    @Published var favoriteMovie: FavoriteMovies?
    @Published var isFavorite : Bool = false
    private var favModel: TitlePreviewViewModel?
    private var id: String?
    private var favoriteMovies: [TitlePreviewViewModel]?
    private var subscriptions: Set<AnyCancellable> = []
    
    func retriveMovies(favModel: TitlePreviewViewModel){
        self.id = Auth.auth().currentUser?.uid
        guard let id = self.id else {return}
        self.favModel = favModel
        DatabaseManager.shared.fetchCollectionFavorites(retrive: id)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.error = error.localizedDescription
                        }
                    } receiveValue: { [weak self] favoriteMovie in
                        self?.favoriteMovie = favoriteMovie
                        self?.favoriteMovies = favoriteMovie.favoriteMovies
                        if favoriteMovie.favoriteMovies.contains(favModel){
                            self?.isFavorite = true
                        }else{
                            self?.isFavorite = false
                        }
                    }.store(in: &subscriptions)
    }
    
    
    func updateFavoriteMovies(){
        guard let id = self.id,
        let favoriteMovies = self.favoriteMovies,
        var favoriteMovie = self.favoriteMovie,
        let favModel = self.favModel
        else{ return }
        if !favoriteMovies.contains(favModel){
            favoriteMovie.favoriteMovies.append(favModel)
            DatabaseManager.shared.addCollectionFavorites(add: favoriteMovie, for: id).sink {
                [weak self] completion in
                if case .failure(let error) = completion{
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }receiveValue: {status in
                print("Movie has been successfully added : \(status)")
            }.store(in: &subscriptions)
        }else{
            print("This Movie Already Added Favorites.")
        }
    }
    
    func deleteFavoriteMovies(){
        guard let id = self.id,
        let favoriteMovies = self.favoriteMovies,
        var favoriteMovie = self.favoriteMovie,
        let favModel = self.favModel
        else{ return }
        if favoriteMovies.contains(favModel){
            guard let index = favoriteMovie.favoriteMovies.firstIndex(of: favModel) else {return}
            favoriteMovie.favoriteMovies.remove(at: index)
            DatabaseManager.shared.addCollectionFavorites(add: favoriteMovie, for: id).sink {
                [weak self] completion in
                if case .failure(let error) = completion{
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }receiveValue: {status in
                print("Movie has been successfully removed : \(status)")
            }.store(in: &subscriptions)
        }else{
            print("This Movie Hasn't Found.")
        }
    }
}
