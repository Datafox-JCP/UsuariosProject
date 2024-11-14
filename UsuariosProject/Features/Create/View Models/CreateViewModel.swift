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
    @Published private(set) var error: FormError?
    @Published var hasError = false
    
    private let validator = Validator()
    
    @MainActor
    func create() async {
        do {
            try validator.validate(user)
            
            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(user)
            
            try await NetworkManager.shared.request(.create(submissionData: data))
            
            state = .succesful
        } catch {
            self.hasError = true
            self.state = .unSuccesful
            
            switch error {
            case is NetworkManager.NetworkError:
                self.error = .networking(error: error as! NetworkManager.NetworkError)
            case is Validator.ValidatorError:
                self.error = .validation(error: error as! Validator.ValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
    }
}

extension CreateViewModel {
    enum SubmissionState {
        case unSuccesful
        case succesful
        case submitting
    }
}

extension CreateViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let error),
                .validation(let error):
            return error.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}
