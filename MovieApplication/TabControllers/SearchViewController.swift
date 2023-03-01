//
//  FeedViewController.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import UIKit


class SearchViewController: UIViewController {
    private var titles: [Title] = [Title]()
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identfier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(searchTableView)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        navigationItem.searchController = searchController
        fetchData()
        searchController.searchResultsUpdater = self
    }
    
    private func fetchData(){
        APICaller.shared.getDiscover { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identfier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let titles = titles[indexPath.row]
        let model = UpcomingTitle(titleName: titles.original_title ?? titles.original_name ?? "Unknown name", posterURL: titles.poster_path ?? "")
        cell.configure(with: model)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let id = title?.id else{return}
                guard let titleOverview = title?.overview else {return}
                guard let posterPath = title?.poster_path else {return}
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

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate{
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {
                    return
            }
        
        resultController.delegate = self
        APICaller.shared.getSearch(with: query) { results in
            DispatchQueue.main.async {
                switch results{
                case (.success(let title)):
                    resultController.titles = title
                    resultController.searchResultCollection.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        }

    }
}



