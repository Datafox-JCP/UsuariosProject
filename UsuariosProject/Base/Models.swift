//
//  Models.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 29/10/24.
//

import Foundation

// MARK: - User
struct User: Codable, Equatable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}

// MARK: - Support
struct Support: Codable, Equatable {
    let url: String
    let text: String
}
