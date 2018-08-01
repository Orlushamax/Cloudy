//
//  City.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//
import Foundation
import Realm
import RealmSwift

class City: Object, Decodable {
    
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
