//
//  NetworkHandler.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import Foundation
import Combine

struct NetworkHandler: NetworkHandlerProtocol {
    
    func run<T: Decodable>(url: String, headers: Headers?) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: url) else {
            let error = URLError(.badURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        
        var urlRequest = URLRequest(url: url)
        
        headers?.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
