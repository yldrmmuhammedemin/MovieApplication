//
//  TitlePreviewViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 17.02.2023.
//

import UIKit
import WebKit
import Alamofire

class TitlePreviewViewController: UIViewController {
    
    private var viewModel = FavoriteMoviesViewModel()
    private var selfModel : TitlePreviewViewModel?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(webView)
        view.addSubview(favoriteAddButton)
        favoriteAddButton.addTarget(self, action: #selector(addFavorite), for: .touchDown)
        configureConstraints()
    }
    
    @objc func addFavorite(){
        viewModel.updateFavoriteMovies(favModel: self.selfModel!)
    }
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
        
        let favoriteAddButton = [
            favoriteAddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteAddButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 30)
        ]
        NSLayoutConstraint.activate(favoriteAddButton)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        
    }
    
    func configure(with model: TitlePreviewViewModel){
            self.selfModel = model
            self.titleLabel.text = model.title
            self.overViewLabel.text = model.titleOverView
            guard let url = URL(string:"https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return}
            self.webView.load(URLRequest(url: url))
     }
    
}
