//
//  OnboardingViewController.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        return label
    }()
    
    private let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        return button
        
    }()
    
    private let createAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Have an already account already ?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.tintColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(signUpButton)
        view.addSubview(createAccountLabel)
        view.addSubview(createAccountLabel)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(toLoginVc), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(toSignUpVc), for: .touchUpInside)
        configureConstraints()
    }
    
    @objc private func toLoginVc() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func toSignUpVc() {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    private func configureConstraints() {
        
        let welcomeLabelConstraints = [
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let createAccountLabelConstraint = [
            createAccountLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            createAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let signUpButtonConstraint = [
            signUpButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let loginButtonConstraint = [
            loginButton.centerYAnchor.constraint(equalTo: createAccountLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: createAccountLabel.trailingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(loginButtonConstraint)
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        NSLayoutConstraint.activate(signUpButtonConstraint)
        NSLayoutConstraint.activate(createAccountLabelConstraint)
    }
    
}
