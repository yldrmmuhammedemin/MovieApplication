//
//  SettingsViewController.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {
    
    private let signOutView: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Çıkış", for: .normal)
        button.titleLabel?.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .heavy)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(signOutView)
        signOutView.addTarget(self, action: #selector(signout), for: .touchUpInside)
        constraintConf()
        sessionControl()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        sessionControl()
    }
    @objc func signout(){
        try? Auth.auth().signOut()
        sessionControl()
    }
    
    func sessionControl(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: false)
        }
    }
        
    private func constraintConf(){
        
        let signOutViewConstraint = [
            signOutView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            signOutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

        ]
        
        NSLayoutConstraint.activate(signOutViewConstraint)
        
    }

}
