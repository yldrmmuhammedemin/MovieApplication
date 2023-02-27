//
//  ProfileHeaderView.swift
//  MovieApplication
//
//  Created by Yildirim on 27.02.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight:.light)
        return label
    }()
    
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "Emin Yildirim"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
     var headerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "puma")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
     var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        //image.image = UIImage(named: "JohnWick")
        return image
    }()
    
    private func confConstraint(){
        let headerImageConstraint = [
            headerImage.topAnchor.constraint(equalTo: topAnchor),
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let profileImageConstraint = [
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            profileImage.centerYAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 10),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let nameLabelConstraint = [
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 10),
        ]
        
        let usernameLabelConstraint = [
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:5)
        ]
        NSLayoutConstraint.activate(usernameLabelConstraint)
        NSLayoutConstraint.activate(headerImageConstraint)
        NSLayoutConstraint.activate(profileImageConstraint)
        NSLayoutConstraint.activate(nameLabelConstraint)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImage)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        confConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
