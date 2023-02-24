//
//  OnboardingViewModel.swift
//  MovieApplication
//
//  Created by Yildirim on 24.02.2023.
//

import Foundation
import Combine
import FirebaseAuth
class OnboardingViewModel: ObservableObject{
    @Published var User?
    @Published var String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retriveUser(){
        guard let id = Auth.auth().currentUser?.uid else {return}
        
        
    }
    
}
