//
//  SearchResultViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 16.02.2023.
//

import UIKit
protocol SearchResultsViewControllerDelegate: AnyObject{
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    public weak var delegate:SearchResultsViewControllerDelegate?
    
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
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        guard let titleOverview = title.overview else{return}
        let id = title.id
        guard let posterPath = title.poster_path else {return}
        APICaller.shared.getMovie(with: titleName + "official trailer") { [weak self] result in
            switch result{
            case .success(let videoElement):
                let viewModel = TitlePreviewViewModel(id: id, title: titleName, youtubeView: videoElement, titleOverView: titleOverview, posterPath: posterPath)
                self?.delegate?.searchResultsViewControllerDidTapItem(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
