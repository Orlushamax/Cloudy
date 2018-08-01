//
//  Forecast.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Forecast: Object, Decodable {
    @objc dynamic var date: String = ""
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var windSpeed: Double = 0.0
    var weather = List<Weather>()
    
    convenience init(date: String, temp: Double, windSpeed: Double, weather: List<Weather>) {
        self.init()
        self.date = date
        self.temp = temp
        self.windSpeed = windSpeed
        self.weather = weather
    }
    
    private enum ForecastCodingKeys: String, CodingKey {
        case date = "dt_txt"
        case main
        case weather
        case wind
    }
    
    private enum MainCodingKeys: String, CodingKey {
        case temp
    }
    
    private enum WindCodingKeys: String, CodingKey {
        case windSpeed = "speed"
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ForecastCodingKeys.self)
        let date = try container.decode(String.self, forKey: .date)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        let temp = try mainContainer.decode(Double.self, forKey: .temp)
        
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        let windSpeed = try windContainer.decode(Double.self, forKey: .windSpeed)
        
        let weatherArray = try container.decode([Weather].self, forKey: .weather)
        let weather = List<Weather>()
        weather.append(objectsIn: weatherArray)
        self.init(date: date, temp: temp, windSpeed: windSpeed, weather: weather)
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
