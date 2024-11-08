//
//  DetailViewModel.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 05/11/24.
//

import Foundation

final class DetailViewModel: ObservableObject {
    @Published private(set) var userInfo: UserDetailResponse?
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError = false
    
    func fetchDetails(for id: Int) {
        NetworkManager.shared.request(
            "https://reqres.in/api/users/\(id)",
            type: UserDetailResponse.self) { [weak self] res in
                DispatchQueue.main.async {
                    switch res {
                    case .success(let response):
                        self?.userInfo = response
                    case .failure(let error):
//                        print(error)
                        self?.hasError = true
                        self?.error = error as? NetworkManager.NetworkError
                    }
                }
            }
    }
}
