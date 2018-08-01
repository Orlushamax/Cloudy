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

class ForecastList: Object, Decodable {
    
    @objc dynamic var cityId: Int = 0
    @objc dynamic var cityName: String = ""
    var list = List<Forecast>()
    
    override class func primaryKey() -> String? {
        return "cityName"
    }
    
    convenience init(cityId: Int, cityName: String, list: List<Forecast>) {
        self.init()
        self.cityId = cityId
        self.cityName = cityName
        self.list = list
    }
    
    private enum ForecastKeys: String, CodingKey {
        case city
        case list
    }
    
    private enum CityKeys: String, CodingKey {
        case cityId = "id"
        case cityName = "name"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ForecastKeys.self)
        let forecast = try container.decode([Forecast].self, forKey: .list)
        let cityContainer = try container.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        let cityId = try cityContainer.decode(Int.self, forKey: .cityId)
        let cityName = try cityContainer.decode(String.self, forKey: .cityName)
        let list = List<Forecast>()
        list.append(objectsIn: forecast)
        self.init(cityId: cityId, cityName: cityName, list: list)
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
