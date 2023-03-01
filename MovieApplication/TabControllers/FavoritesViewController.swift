//
//  FavoritesViewController.swift
//  Application
//
//  Created by Yildirim on 14.02.2023.
//

import UIKit
import FirebaseAuth
import Combine
class FavoritesViewController: UIViewController {
    private var titles:[TitlePreviewViewModel] = [TitlePreviewViewModel]()
    private var subscriptions: Set<AnyCancellable> = []
    private var error : String?
    private var user: AppUser?
    
    let favoritesTable: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identfier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(favoritesTable)
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        fetchData()
  
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTable.frame = view.bounds
    }
    
    private func fetchData(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.error = error.localizedDescription
                        }
                    } receiveValue: { [weak self] user in
                        DispatchQueue.main.async {
                            self?.user = user
                            self?.titles = user.favoriteMovies
                            self?.favoritesTable.reloadData()
                        }
                    }
                    .store(in: &subscriptions)
    }
    
    private func deleteFavoriteMovie(){
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identfier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = self.titles[indexPath.row]
        cell.configure(with:UpcomingTitle(titleName: title.title, posterURL: title.posterPath ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                    let selectedRowIndex = indexPath.row
                    deleteFavoriteMovie()
                }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = self.titles[indexPath.row]
        let titleName = title.title 
        APICaller.shared.getMovie(with: titleName + "official trailer") { [weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.titleOverView else{return}
                guard let id = title?.id else{return}
                guard let posterPath = title?.posterPath else {return}
                let viewModel = TitlePreviewViewModel(id: id, title: titleName, youtubeView: videoElement, titleOverView: titleOverview, posterPath: posterPath)
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

