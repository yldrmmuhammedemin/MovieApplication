//
//  AppUserModelView.swift
//  MovieApplication
//
//  Created by Yildirim on 24.02.2023.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseStorage
import UIKit

class AppUserViewModel: ObservableObject{
    private var subscription : Set<AnyCancellable> = []
    @Published var id : String?
    @Published var displayName : String?
    @Published var username : String?
    @Published var avatarPath : String?
    @Published var isFormValid : Bool = false
    @Published var error : String?
    @Published var url : URL?
    @Published var imageData : UIImage?
    @Published var isOnBoardingFinish : Bool = false
 
    
    func validatePorfileForm(){
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              imageData != nil else{
            return
        }
        isFormValid = true
    }
    

    
    func uploadAvatar(){
        let randomID = UUID().uuidString
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else {return}
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metadata).flatMap { metadata in
            StorageManager.shared.getDownloadURL(for: metadata.path)
        }.sink { [weak self] completion in
            switch completion{
            case .failure(let error):
                self?.error = error.localizedDescription
            case .finished:
                self?.updateUser()
            }
        } receiveValue: { [weak self] url in
            self?.avatarPath = url.absoluteString
        }.store(in: &subscription)
    }
    
    private func updateUser(){
        guard let username,
              let id = Auth.auth().currentUser?.uid,
              let displayName,
              let avatarPath else {return}
        let updateFields: [String:Any] = [
            "displayName": displayName,
            "username": username,
            "avatarPath": avatarPath,
            "isUserOnboarded": true
        ]
        
        DatabaseManager.shared.collectionUsers(updateFields: updateFields, for: id).sink { [weak self] completion in
            if case .failure(let error) = completion{
                print(error.localizedDescription)
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] onboardingStatus in
            self?.isOnBoardingFinish = onboardingStatus
        }.store(in: &subscription)

        
    }
}

