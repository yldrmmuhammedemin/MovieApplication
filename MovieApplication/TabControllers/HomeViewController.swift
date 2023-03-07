//
//  HomeViewController.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import UIKit
import FirebaseAuth
import Combine


private let sectionHeaders = ["Trendıng Movıes", "Trendıng Tv", "Popular", "Upcomıng Movıes", "Top Rated"]

private var viewModel = HomeViewViewModel()
private var subscription : Set<AnyCancellable> = []

    enum Sections: Int{
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    }

class HomeViewController: UIViewController {
    private let HomeFeedTable: UITableView = {
         
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(HomeFeedTable)
        HomeFeedTable.delegate = self
        HomeFeedTable.dataSource = self
        let headerTableView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        HomeFeedTable.tableHeaderView = headerTableView
        navbarConf()
        bindView()
    }
    
    private func navbarConf(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(toProfile))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .done, target: self, action: #selector(toLogout))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func toProfile(){
        let vc = ProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func toLogout(){
        try? Auth.auth().signOut()
        sessionControl()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        HomeFeedTable.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionControl()
        navigationController?.navigationBar.isHidden = false
        viewModel.retriveUser()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
    }
    
    func sessionControl(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: false)
        }
    }
    
    func completeUserOnboarding(){
        let vc = UserRegisterViewController()
        present(vc, animated: true)
    }
    
    func bindView(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else {return}
            if !user.isUserOnboarded {
                self?.completeUserOnboarding()
            }
        }.store(in: &subscription)
        
    }

}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result{
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result{
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result{
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
         return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18 , weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 28, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLatter()
         
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        

    }
}
