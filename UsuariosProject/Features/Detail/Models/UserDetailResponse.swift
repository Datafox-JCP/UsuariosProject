//
//  UserDetailResponse.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 31/10/24.
//

import Foundation

// MARK: - UserDetailResponse
struct UserDetailResponse: Codable, Equatable {
    let data: User
    let support: Support
}


