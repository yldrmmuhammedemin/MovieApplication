//
//  ProfileHeaderView.swift
//  MovieApplication
//
//  Created by Yildirim on 27.02.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Emin Yildirim"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "puma")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.image = UIImage(named: "JohnWick")
        return image
    }()
    
    private func confConstraint(){
        let headerImageConstraint = [
            headerImage.topAnchor.constraint(equalTo: topAnchor),
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let profileImageConstraint = [
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            profileImage.centerYAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 10),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let nameLabelConstraint = [
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            nameLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(headerImageConstraint)
        NSLayoutConstraint.activate(profileImageConstraint)
        NSLayoutConstraint.activate(nameLabelConstraint)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImage)
        addSubview(profileImage)
        addSubview(nameLabel)
        confConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
