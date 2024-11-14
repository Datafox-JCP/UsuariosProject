//
//  Endpoint.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 12/11/24.
//

import Foundation

enum Endpoint {
    case people(page: Int)
    case detail(id: Int)
//    case create - añadir el de abajo después de MethodType
    case create(submissionData: Data?)
}

extension Endpoint {
    enum MethodType {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    
    var host: String { "reqres.in" }
    
    var path: String {
        switch self {
        case .people, .create:
            return "/api/users"
        case .detail(let id):
            return "/api/users/\(id)"
//        case .create:
//            return "api/users"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .people, .detail:
            return .GET
        case .create(let data):
            return .POST(data: data)
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .people(let page):
            return ["page":"\(page)"]
        default:
            return nil
        }
    }
}

extension Endpoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = queryItems?.compactMap { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        
        #if DEBUG
            requestQueryItems?.append(URLQueryItem(name: "delay", value: "3"))
        #endif
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
