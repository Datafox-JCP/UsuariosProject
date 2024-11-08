//
//  CreateViewModel.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 06/11/24.
//

import Foundation

final class CreateViewModel: ObservableObject {
    
    @Published var user = NewUser()
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError = false
    
    func create() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(user)
        
        NetworkManager.shared.request(methodType: .POST(data: data), "https://reqres.in/api/users") { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    self?.state = .succesful
                case .failure(let error):
                    self?.state = .unSuccesful
                    self?.hasError = true
                    self?.error = error as? NetworkManager.NetworkError
                }
            }
        }
    }
}

extension CreateViewModel {
    enum SubmissionState {
        case unSuccesful
        case succesful
    }
}
