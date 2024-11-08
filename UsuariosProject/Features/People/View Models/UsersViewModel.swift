//
//  UsersViewModel.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 05/11/24.
//

import Foundation

final class UsersViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError = false
    
    func fetchUsers() {
        NetworkManager.shared.request(
            "https://reqres.in/api/users",
            type: UsersResponse.self) { [weak self] res in
                DispatchQueue.main.async {
                    switch res {
                    case .success(let response):
                        self?.users = response.data
                    case .failure(let error):
//                        print(error)
                        self?.hasError = true
                        self?.error = error as? NetworkManager.NetworkError
                    }
                }
            }
    }
}
