//
//  ComingSoonViewController.swift
//  Application
//
//  Created by Yildirim on 14.02.2023.
//

import UIKit

class ComingSoonViewController: UIViewController {
    private var titles:[Title] = [Title]()
    
    let upComingTable: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identfier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upComingTable)
        upComingTable.delegate = self
        upComingTable.dataSource = self
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTable.frame = view.bounds
    }
    
    private func fetchData(){
        
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upComingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        
        }
        
    }
}
extension ComingSoonViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identfier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with:UpcomingTitle(titleName: (title.original_title) ?? title.original_name ?? "Unknown Title Name" , posterURL: title.poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        //print(title.original_title ?? title.original_name)
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else{return}
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverView: titleOverview)
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
