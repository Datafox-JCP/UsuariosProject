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
    @Published private(set) var isLoading = false
    @Published var hasError = false
    
    @MainActor
    func fetchDetails(for id: Int) async {
        isLoading.toggle()
        
        defer { isLoading = false }
        
        do {
            self.userInfo = try await NetworkManager.shared.request(.detail(id: id), type: UserDetailResponse.self)
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkManager.NetworkError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
