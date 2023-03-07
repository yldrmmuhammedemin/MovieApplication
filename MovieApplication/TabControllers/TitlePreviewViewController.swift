//
//  TitlePreviewViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 17.02.2023.
//

import UIKit
import WebKit
import Alamofire
import Combine
class TitlePreviewViewController: UIViewController {
    
    private var viewModel = FavoriteMoviesViewModel()
    private var selfModel : TitlePreviewViewModel?
    private var subscripition : Set<AnyCancellable> = []
    // MARK: - Favorite DidSet Function
    private var isFavorite : Bool = false{
        didSet{
            if self.isFavorite{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "heart.fill"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(didTapFav))
                print(isFavorite)
            }
            else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "heart"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(didTapFav))
            }
        }
    }
    // MARK: - Added Component
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    private let overViewLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteAddButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
        return button
    }()
    // MARK: - Subview Add Functions
    fileprivate func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(webView)
    }
    // MARK: - viewdidload Function
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        navbarConf()
        favControl()
    }
    // MARK: - Get the favorite data
    private func favControl(){
        viewModel.retriveMovies(favModel: self.selfModel!)
        viewModel.$isFavorite.sink { [weak self] isFavorite in
            self?.isFavorite = isFavorite
            }.store(in: &self.subscripition)
    }
    // MARK: - Send favorite data when screen disappear
    override func viewWillDisappear(_ animated: Bool) {
        if isFavorite{
            addFavorite()

        }
        else{
            deleteFavorite()
        }
    }
    // MARK: - Remove favorite function
    private func deleteFavorite(){
        viewModel.deleteFavoriteMovies()
    }
    // MARK: - Add favorite function
    private func addFavorite(){
        viewModel.updateFavoriteMovies()
    }
    // MARK: - Favorite button function
    @objc private func didTapFav(){
        self.isFavorite = !isFavorite
    }
    // MARK: - Navigationbar configuration
    private func navbarConf(){
        didTapFav()
    }
    // MARK: - Constraints of configuration
    private func configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            webView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let overviewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        
    }
    // MARK: - Setting models to screen
    func configure(with model: TitlePreviewViewModel){
            self.selfModel = model
            self.titleLabel.text = model.title
            self.overViewLabel.text = model.titleOverView
            guard let url = URL(string:"https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return}
            self.webView.load(URLRequest(url: url))
     }
    
}
