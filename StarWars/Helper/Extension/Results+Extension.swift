//
//  Results+Extension.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import RealmSwift

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
