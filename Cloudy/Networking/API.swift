//
//  API.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import Moya
import RealmSwift

class API {
    
    static let apiKey = "85ed85643a17ae6e017b42b7dd50fb56"
    static let units = "metric"
    static let provider = MoyaProvider<Endpoint>()
    
    static func getForecastWeather(cityName: String, completion: @escaping (ForecastList?, MoyaError?) -> ()) {
        provider.request(.forecast(cityName: cityName)) { result in
            switch result {
            case let .success(response):
                do {
                    let cityForecast = try JSONDecoder().decode(ForecastList.self, from: response.data)
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(cityForecast, update: true)
                    }
                    completion(cityForecast, nil)
                } catch let error {
                    print(error)
                    completion(nil, nil)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}
