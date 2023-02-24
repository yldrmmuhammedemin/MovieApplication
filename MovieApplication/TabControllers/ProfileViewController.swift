//
//  ProfileViewController.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let titles = [Title]()
    let isStatusBarHidden: Bool = true
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identfier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let headerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.image = UIImage(named: "puma")
        image.contentMode = .scaleAspectFit
        return image
        
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = false
        image.image = UIImage(named: "JohnWick")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Profile"
        view.addSubview(tableView)
        view.addSubview(profileImage)
        view.addSubview(headerImage)
    }
    
    private func confConstraint(){
        let tableViewConstraint = [
            tableView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let profileImageConstraint = [
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: headerImage.bottomAnchor,constant: 10 ),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 50)
        
        ]
        
        let headerImageConstraint = [
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerImage.heightAnchor.constraint(equalToConstant: 20),
            headerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraint)
        NSLayoutConstraint.activate(profileImageConstraint)
        NSLayoutConstraint.activate(headerImageConstraint)
    }


}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identfier, for: indexPath) as? TitleTableViewCell
        else{
            return UITableViewCell()
        }
        return cell
    }
    

}
