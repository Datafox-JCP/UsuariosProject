//
//  NetworkManager.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 05/11/24.
//

import Foundation

// Handle and manage network calls
// Singleton is an object that create once and share everiwhere

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: Get
    func request<T: Codable> (_ endPoint: Endpoint, type: T.Type) async throws -> T {
        guard let url = endPoint.url else {
            throw NetworkError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endPoint.methodType)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(T.self, from: data)
        
        return res
    }
    
    // MARK: - Post
    func request(_ endPoint: Endpoint) async throws {
        guard let url = endPoint.url else {
            throw NetworkError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endPoint.methodType)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
    }
}

// MARK: Manejo de errores
extension NetworkManager {
    enum NetworkError: Error, LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkManager.NetworkError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "La URL no es correcta"
        case .custom(let error):
            return "Algo salió mal \(error.localizedDescription)"
        case .invalidStatusCode(_):
            return "El código de estado está en el rango incorrecto"
        case .invalidData:
            return "Los datos de respuesta son incorrectos"
        case .failedToDecode(_):
            return "Falla al decodificar"
        }
    }
}

// MARK: Contruir request
private extension NetworkManager {
    func buildRequest(from url: URL, methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        
        return request
    }
}
