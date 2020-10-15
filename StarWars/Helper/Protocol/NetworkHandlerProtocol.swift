//
//  NetworkHandlerProtocol.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import Foundation
import Combine

protocol NetworkHandlerProtocol {
    typealias Headers = [String: Any]
    
    func run<T: Decodable>(url: String, headers: Headers?) -> AnyPublisher<T, Error>
}
