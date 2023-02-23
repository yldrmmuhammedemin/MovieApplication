//
//  HeroHeaderView.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import UIKit

class HeroHeaderView: UIView {
    
   private let playButton: UIButton = {
       let button = UIButton()
       button.translatesAutoresizingMaskIntoConstraints = false
       button.setTitle("Play", for: .normal)
       //button.layer.cornerRadius = 5
       button.layer.borderWidth = 1
       button.layer.cornerRadius = 5
       button.layer.borderColor = UIColor.white.cgColor
       return button
   }()
    
   private let headerImage: UIImageView = {
       let image = UIImageView()
       image.image = UIImage(named: "JohnWick")
       image.contentMode = .scaleAspectFill
       image.clipsToBounds = true
       return image
    }()
    
    private func gradientColor(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImage)
        gradientColor()
        addSubview(playButton)
        configureConstraints()
    }
    
    private func configureConstraints(){
        let playButtonConstraint = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(50)),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraint)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImage.frame = bounds
    }
}
