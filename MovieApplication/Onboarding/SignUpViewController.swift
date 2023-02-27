//
//  signUpViewController.swift
//  Application
//
//  Created by Yildirim on 13.02.2023.
//

import UIKit
import Combine
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel = AuthenticationViewViewModel()
    
    private let loginTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign Up"
        label.tintColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle( "Sign Up", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(loginTextLabel)
        bindView()
        loginButton.addTarget(self, action:#selector(tapSignUp), for: .allTouchEvents)
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(editDismiss)))
        configConstraints()
    }
    @objc private func tapSignUp(){
        viewModel.createUser()
//            if emailTextField.text != "" && passwordTextField.text != "" {
//                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ AuthDataResult, error in
//                    if error != nil {
//                        self.presentAlert(error: error?.localizedDescription ?? "Error, try Again")
//                    }else{
//                        guard let vc = self.navigationController?.viewControllers.first as? OnboardingViewController else {return}
//                        vc.dismiss(animated: true)                }
//                }
//            }
        }
    
    @objc private func editDismiss(){
        view.endEditing(true)
    }

    private func bindView(){
        emailTextField.addTarget(self, action: #selector(editEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editPassword), for: .editingChanged)

        viewModel.$isAuthenticationFormValid.sink { [weak self] isValidate in
            self?.loginButton.isEnabled = isValidate
        }.store(in: &subscriptions)

        viewModel.$user.sink { [weak self] user in
            guard user != nil else {return}
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else {return}
            vc.dismiss(animated: true)
        }.store(in: &subscriptions)

        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else {return}
            self?.presentAlert(error: error)
        }.store(in: &subscriptions)
    }

    private func presentAlert(error:String){
        let alertMessage = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertMessage.addAction(okButton)
        present(alertMessage, animated: true)
    }
    
    @objc private func editEmail() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()

    }

    @objc private func editPassword() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    private func configConstraints() {
        let emailTextFieldConstraint = [
            emailTextField.topAnchor.constraint(equalTo: loginTextLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let passwordTextFieldConstraint = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let loginTextLabelConstraint = [
            loginTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loginTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let loginButtonConstraint = [
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(loginTextLabelConstraint)
        NSLayoutConstraint.activate(passwordTextFieldConstraint)
        NSLayoutConstraint.activate(emailTextFieldConstraint)
        NSLayoutConstraint.activate(loginButtonConstraint)
    }
    
}
