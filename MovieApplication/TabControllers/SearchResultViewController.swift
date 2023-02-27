//
//  SearchResultViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 16.02.2023.
//

import UIKit

class SearchResultViewController: UIViewController {
    public var titles: [Title] = [Title]()
    public let searchResultCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10, height: 140)
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultCollection)
        searchResultCollection.delegate = self
        searchResultCollection.dataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollection.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell() }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
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
