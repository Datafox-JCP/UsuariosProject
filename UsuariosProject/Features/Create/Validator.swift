//
//  Validator.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 11/11/24.
//

import Foundation

struct Validator {
    func validate(_ user: NewUser) throws {
        if user.firstName.isEmpty {
            throw ValidatorError.invalidFirstName
        }
        
        if user.lastName.isEmpty {
            throw ValidatorError.invalidLastName
        }
        
        if user.job.isEmpty {
            throw ValidatorError.invalidJob
        }
    }
}

extension Validator {
    enum ValidatorError: LocalizedError {
        case invalidFirstName
        case invalidLastName
        case invalidJob
    }
}

extension Validator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .invalidFirstName:
            return "El nombre no puede estar vacio"
        case .invalidLastName:
            return "El apellido no puede estar vacio"
        case .invalidJob:
            return "El trabajo no puede estar vacio"
        }
    }
}
