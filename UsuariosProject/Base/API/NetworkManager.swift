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
    func request<T: Codable> (
        methodType: MethodType = .GET,
        _ absoluteURL: String,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Asegurarse que haya URL
        guard let url = URL(string: absoluteURL) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        let request = buildRequest(from: url, methodType: methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            // Verificar que no haya errores
            if error != nil {
                completion(.failure(NetworkError.custom(error: error!)))
                return
            }
            
            // Verificar que haya respuesta
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            // Veriricar que haya datos
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            // Decodificar respuesta
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self, from: data)
                completion(.success(res))
            } catch {
                completion(.failure(NetworkError.failedToDecode(error: error)))
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Post
    func request(
        methodType: MethodType = .GET,
        _ absoluteURL: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Asegurarse que haya URL
        guard let url = URL(string: absoluteURL) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        let request = buildRequest(from: url, methodType: methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            // Verificar que no haya errores
            if error != nil {
                completion(.failure(NetworkError.custom(error: error!)))
                return
            }
            
            // Verificar que haya respuesta
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            completion(.success(()))
        }
        dataTask.resume()
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

// MARK: Tipos
extension NetworkManager {
    enum MethodType {
        case GET
        case POST(data: Data?)
    }
}

// MARK: Contruir request
private extension NetworkManager {
    func buildRequest(from url: URL, methodType: MethodType) -> URLRequest {
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
