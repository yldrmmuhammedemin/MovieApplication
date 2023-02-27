//
//  TableViewCell.swift
//  FilmApplication
//
//  Created by Yildirim on 16.02.2023.
//

import UIKit
import Kingfisher

class TitleTableViewCell: UITableViewCell {
static let identfier = "TitleTableViewCell"
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        configureConstraints()
    }
    
    private func configureConstraints(){
        
        let posterImageViewConstraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
        
        let playButtonContraint = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let titleLabelConstraint = [
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(playButtonContraint)
        NSLayoutConstraint.activate(titleLabelConstraint)
    }
    
    public func configure(with model: UpcomingTitle){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        posterImageView.kf.setImage(with: url)
        titleLabel.text = model.titleName
    }
}
