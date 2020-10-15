//
//  SWPeopleModel.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import Foundation

// MARK: - SWPeopleModel
final class SWPeopleModel: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [SWPeopleResultModel]?
}
