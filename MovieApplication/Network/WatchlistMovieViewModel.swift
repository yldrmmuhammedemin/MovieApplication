//
//  WatchlistViewModel.swift
//  MovieApplication
//
//  Created by Yildirim on 7.03.2023.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class WatchlistMovieViewModel: ObservableObject{
    @Published var watchlist: Watchlists?
    @Published var error: String?
    @Published var isWatchlistAdded: Bool = false
    private var watchlistModel: TitlePreviewViewModel?
    private var watchlistModels: [TitlePreviewViewModel]?
    private var subscriber: Set<AnyCancellable> = []
    private var id : String?
    
    func getWatchlistMovie(watchModel:TitlePreviewViewModel){
        self.id = Auth.auth().currentUser?.uid
        self.watchlistModel = watchModel
        guard let id = self.id else {return}
        DatabaseManager.shared.fetchCollectionWatchlists(retrive: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] watchlist in
                self?.watchlist = watchlist
                self?.watchlistModels = watchlist.watchlists
                if watchlist.watchlists.contains(watchModel){
                    self?.isWatchlistAdded = true
                }else{
                    self?.isWatchlistAdded = false
                }
            }.store(in: &subscriber)
    }
    
    func addWatchlistMovie(){
        guard let id = self.id,
              let addModel = self.watchlistModel,
              //let watchlistModels = self.watchlistModels,
              var watchlist = self.watchlist
        else{return}
        if !watchlist.watchlists.contains(addModel){
            watchlist.watchlists.append(addModel)
            DatabaseManager.shared.addCollectionWatchlists(add: watchlist, for: id).sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { status in
                print("The movie has been added successfully.\(status)")
            }.store(in: &subscriber)
        }
        else{
            print("This movie already added watchlist")
        }
    }
    
    func removeWatchlistMovie(){
        guard let id = self.id,
              let addModel = self.watchlistModel,
              //let watchlistModels = self.watchlistModels,
              var watchlist = self.watchlist
        else{return}
        if watchlist.watchlists.contains(addModel){
            guard let index = watchlist.watchlists.firstIndex(of: addModel) else {return}
            watchlist.watchlists.remove(at: index)
            DatabaseManager.shared.addCollectionWatchlists(add: watchlist, for: id).sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { status in
                print("The movie has been successfully removed.\(status)")
            }.store(in: &subscriber)
        }
        else{
            print("This movie couldn't find.")
        }
    }
}
