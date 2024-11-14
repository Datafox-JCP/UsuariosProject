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
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private var page = 1
    private var totalPages: Int?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    @MainActor
    func fetchUsers() async {
        reset()
//        isLoading.toggle()
        viewState = .loading
        
//        defer { isLoading = false }
        defer { viewState = .finished }
        
        do {
            let response = try await NetworkManager.shared.request(.people(page: page), type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkManager.NetworkError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfUsers() async {
        
        guard page != totalPages else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        do {
            let response = try await NetworkManager.shared.request(.people(page: page), type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users += response.data // este es el diferente
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkManager.NetworkError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}

extension UsersViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension UsersViewModel {
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}
