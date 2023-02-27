//
//  ProfileViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import UIKit
import Combine
import Kingfisher

class ProfileViewController: UIViewController {
    var subscriptions: Set<AnyCancellable> = []
    
    var titles = [Title]()
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
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Profile"
        navigationController?.navigationBar.isHidden = true
        view.addSubview(tableView)
        view.addSubview(statusBar)
        tableView.tableHeaderView = headerView
        confConstraint()
        fetchData()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retriveUser()
    }
    
    private func bindView(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else{return}
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
        APICaller.shared.getDiscover { [weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identfier, for: indexPath) as? TitleTableViewCell
        else{
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition > 150 && isStatusBarHidden{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {[weak self] in
                self?.statusBar.layer.opacity = 1
            }completion: { _ in }
        }
        else if yPosition < 0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {[weak self] in
                self?.statusBar.layer.opacity = 0
            }completion: { _ in }
        }
    }

}
