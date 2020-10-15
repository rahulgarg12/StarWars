//
//  Enums.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import Foundation

//MARK: SWDetailView
enum SWDetailViewControllerSection: Int, CaseIterable {
    case name = 0
    case height
    case mass
    case hairColor
    case skinColor
    case eyeColor
    case birthYear
    case gender
    case homeworld
    case films
    case species
    case vehicles
    case starships
    case created
    case edited
    case url
    
    var title: String {
        switch self {
        case .name:         return "Name"
        case .height:       return "Height (CM)"
        case .mass:         return "Weight (KG)"
        case .hairColor:    return "Hair Color"
        case .skinColor:    return "Skin Color"
        case .eyeColor:     return "Eye Color"
        case .birthYear:    return "Birth Year"
        case .gender:       return "Gender"
        case .homeworld:    return "Homeworld"
        case .films:        return "Films"
        case .species:      return "Species"
        case .vehicles:     return "Vehicles"
        case .starships:    return "Starships"
        case .created:      return "Created At"
        case .edited:       return "Edited At"
        case .url:          return "URL"
        }
    }
}


//MARK:- SWDetail TableCell
enum SWDetailViewCellAction {
    case selected(SWFilmModel)
}
