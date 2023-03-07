//
//  ProfileViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import UIKit
import Combine
import Kingfisher
import Firebase
import FirebaseAuth
class ProfileViewController: UIViewController {
    var subscriptions: Set<AnyCancellable> = []
    var error: String?
    private var watchlistModel: Watchlists?
    private var watchlistsModel: [TitlePreviewViewModel] = [TitlePreviewViewModel]()
    private var id: String?
    var isStatusBarHidden: Bool = true
    private var viewModel = ProfileViewModel()
    let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identfier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 280))

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConf()
        navigationItemConf()
        subviewConf()
        confConstraint()
        bindView()
        retriveData()
        fetchData()
    }
    
    private func navigationItemConf(){
        navigationItem.title = "Profile"
        navigationController?.navigationBar.isHidden = true
    }
    private func tableViewConf(){
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func subviewConf(){
        view.addSubview(tableView)
        view.addSubview(statusBar)
    }
    private func retriveData(){
        viewModel.retriveUser()
        viewModel.getWatchlistMovie()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        fetchData()
    }
    
    private func bindView(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else{return}
            self?.id = user.id
            DispatchQueue.main.async {
                self?.headerView.nameLabel.text = "\(user.displayName)"
                self?.headerView.usernameLabel.text = "@\(user.username)"
                let url = URL(string: user.avatarPath)
                self?.headerView.profileImage.kf.setImage(with: url)
            }
        }.store(in: &subscriptions)
    }
    
    private func confConstraint(){
        let tableViewConstraint = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraint = [
            statusBar.topAnchor.constraint(equalTo: view.bottomAnchor),
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        
        NSLayoutConstraint.activate(tableViewConstraint)
        NSLayoutConstraint.activate(statusBarConstraint)
    }
    
    private func fetchData(){
        viewModel.$watchlist.sink{[weak self] watchlist in
            guard let watchlist = watchlist else{return}
            self?.watchlistModel = watchlist
            self?.watchlistsModel = watchlist.watchlists
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &subscriptions)
        
//
//        guard let id = Auth.auth().currentUser?.uid else { return }
//        DatabaseManager.shared.fetchCollectionWatchlists(retrive: id).sink { [weak self] completion in
//            if case .failure(let error) = completion{
//                self?.error = error.localizedDescription
//            }
//        } receiveValue: { [weak self] watchlist in
//            self?.watchlistModel = watchlist
//            self?.watchlistsModel = watchlist.watchlists
//            DispatchQueue.main.async {
//
//                self?.tableView.reloadData()
//            }
//        }.store(in: &subscriptions)

//        APICaller.shared.getDiscover { [weak self] result in
//            switch result{
//            case .success(let titles):
//                self?.titles = titles
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identfier, for: indexPath) as? TitleTableViewCell
        else{
            return UITableViewCell()
        }
        let titles = watchlistsModel[indexPath.row]
        let model = UpcomingTitle(titleName: titles.title, posterURL: titles.posterPath)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = self.watchlistsModel[indexPath.row]
        let titleName = title.title
        APICaller.shared.getMovie(with: titleName + "official trailer") { [weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self?.watchlistsModel[indexPath.row]
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
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yPosition = scrollView.contentOffset.y
//        if yPosition > 150 && isStatusBarHidden{
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {[weak self] in
//                self?.statusBar.layer.opacity = 1
//            }completion: { _ in }
//        }
//        else if yPosition < 0 && !isStatusBarHidden{
//            isStatusBarHidden = true
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {[weak self] in
//                self?.statusBar.layer.opacity = 0
//            }completion: { _ in }
//        }
//    }

}
