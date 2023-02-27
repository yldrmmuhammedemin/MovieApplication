//
//  UserRegisterViewController.swift
//  MovieApplication
//
//  Created by Yildirim on 24.02.2023.
//

import UIKit
import Combine
import PhotosUI

class UserRegisterViewController: UIViewController {
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel = AppUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarPlaceHolderImageView)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(submitButton)
        isModalInPresentation = true
        displayNameTextField.delegate = self
        usernameTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismiss)))
        submitButton.addTarget(self, action:#selector(didTapSubmit), for: .touchUpInside)
        avatarPlaceHolderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpload)))
        ConstraintConf()
        bindViews()
    }
    
    @objc func didTapSubmit(){
        viewModel.uploadAvatar()
    }
    
    @objc func didTapToUpload(){
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    private func bindViews(){
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        viewModel.$isFormValid.sink { [weak self] buttonState in
            self?.submitButton.isEnabled = buttonState
               }.store(in: &subscriptions)
        
        viewModel.$isOnBoardingFinish.sink{ [weak self] status in
            if status{
                self?.dismiss(animated: true)
            }
        }.store(in: &subscriptions)
    }
    
    @objc private func didTapDismiss(){
        view.endEditing(true)
    }
    
    @objc private func didUpdateDisplayName(){
        viewModel.displayName = displayNameTextField.text
        viewModel.validatePorfileForm()
    }
    
    @objc private func didUpdateUsername(){
        viewModel.username = usernameTextField.text
        viewModel.validatePorfileForm()
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let displayNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Display Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fill In Your Data"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let avatarPlaceHolderImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    
    private func ConstraintConf(){
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let hintLabelConstraint = [
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)
        ]
        
        let avatarPlaceHolderImageViewConstraints = [
            avatarPlaceHolderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceHolderImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarPlaceHolderImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarPlaceHolderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30)
        ]
        
        let displayNameTextFieldConstraint = [
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameTextField.topAnchor.constraint(equalTo: avatarPlaceHolderImageView.bottomAnchor, constant: 40),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let usernameTextFieldConstraints = [
            usernameTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            usernameTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(avatarPlaceHolderImageViewConstraints)
        NSLayoutConstraint.activate(hintLabelConstraint)
        NSLayoutConstraint.activate(displayNameTextFieldConstraint)
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
        NSLayoutConstraint.activate(submitButtonConstraints)
    }
}

extension UserRegisterViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y-100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension UserRegisterViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results{
            result.itemProvider.loadObject(ofClass: UIImage.self){[weak self] object, error in
                if let image = object as? UIImage{
                    DispatchQueue.main.async {
                        self?.avatarPlaceHolderImageView.image = image
                        self?.viewModel.imageData = image
                        self?.viewModel.validatePorfileForm()
                    }
                }
                
                
            }
        }
    }
    
    
    
}
