//
//  DBHandler.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import RealmSwift

final class DBHandler {
    static let serialQueue = DispatchQueue(label: "com.db.serial")
    
    static func clearRealmData() {
        let realm = try? Realm()
        try? realm?.write {
            DBHandler.serialQueue.sync {
                realm?.deleteAll()
            }
        }
    }
    
    static func refreshRealmData() {
        let realm = try? Realm()
        realm?.refresh()
    }
}

extension DBHandler {
    func save(model: SWPeopleResultModel) {
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                if !model.isInvalidated {
                    DBHandler.serialQueue.sync {
                        model.timestamp = Date().timeIntervalSince1970
                        realm?.add(model)
                    }
                }
            }
        }
    }
    
    func delete(key: String?) {
        guard let model = getPeopleModel(for: key) else { return }
        
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DBHandler.serialQueue.sync {
                    realm?.delete(model)
                }
            }
        }
    }
    
    func getAllPeopleModels() -> Results<SWPeopleResultModel>? {
        autoreleasepool {
            let realm = try? Realm()
            return realm?.objects(SWPeopleResultModel.self).sorted(byKeyPath: "timestamp", ascending: true)
        }
    }
    
    func getPeopleModel(for key: String?) -> SWPeopleResultModel? {
        autoreleasepool {
            let realm = try? Realm()
            return realm?.object(ofType: SWPeopleResultModel.self, forPrimaryKey: key)
        }
    }
}
