//
//  Weather.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Weather: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var main: String = ""
    @objc dynamic var descr: String = ""
    @objc dynamic var icon: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    private enum DayWeatherKeys: String, CodingKey {
        case id
        case main
        case descr = "description"
        case icon
    }
    
    convenience init(id: Int, main: String, descr: String, icon: String) {
        self.init()
        self.id = id
        self.main = main
        self.descr = descr
        self.icon = icon
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DayWeatherKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let main = try container.decode(String.self, forKey: .main)
        let descr = try container.decode(String.self, forKey: .descr)
        let icon = try container.decode(String.self, forKey: .icon)
        self.init(id: id, main: main, descr: descr, icon: icon)
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
