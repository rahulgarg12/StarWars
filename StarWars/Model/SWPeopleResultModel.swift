//
//  SWPeopleResultModel.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import RealmSwift

// MARK: - Result
final class SWPeopleResultModel: Object, Codable {
    @objc dynamic var name: String?
    @objc dynamic var height: String?
    @objc dynamic var mass: String?
    @objc dynamic var hairColor: String?
    @objc dynamic var skinColor: String?
    @objc dynamic var eyeColor: String?
    @objc dynamic var birthYear: String?
    @objc dynamic var gender: String?
    @objc dynamic var homeworld: String?
    let films = List<String>()
    let species = List<String>()
    let vehicles = List<String>()
    let starships = List<String>()
    dynamic var created: String?
    dynamic var edited: String?
    @objc dynamic var url: String? = ""
    
    @objc dynamic var timestamp: Double = 0
    

    private enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
    
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(String.self, forKey: .height)
        self.mass = try container.decode(String.self, forKey: .mass)
        self.hairColor = try container.decode(String.self, forKey: .hairColor)
        self.skinColor = try container.decode(String.self, forKey: .skinColor)
        self.eyeColor = try container.decode(String.self, forKey: .eyeColor)
        self.birthYear = try container.decode(String.self, forKey: .birthYear)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.homeworld = try container.decode(String.self, forKey: .homeworld)
        
        if let films = try container.decodeIfPresent([String].self, forKey: .films) {
            self.films.append(objectsIn: films)
        }
        if let species = try container.decodeIfPresent([String].self, forKey: .species) {
            self.species.append(objectsIn: species)
        }
        if let vehicles = try container.decodeIfPresent([String].self, forKey: .vehicles) {
            self.vehicles.append(objectsIn: vehicles)
        }
        if let starships = try container.decodeIfPresent([String].self, forKey: .starships) {
            self.starships.append(objectsIn: starships)
        }
        
        self.created = try container.decode(String.self, forKey: .created)
        self.edited = try container.decode(String.self, forKey: .edited)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    
    override static func primaryKey() -> String? {
        return "url"
    }
}
