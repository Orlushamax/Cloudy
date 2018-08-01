//
//  Endpoint.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import Moya

enum Endpoint {
    case forecast(cityName: String) //MARK: 5 days weather forecast
}

extension Endpoint: TargetType {
    var baseURL: URL {
        switch self {
        case .forecast:
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/") else { fatalError("baseURL could not be configured") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .forecast:
            return "forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forecast:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .forecast(let cityName):
            let params: [String : Any] = [
                "q": cityName,
                "APPID": API.apiKey,
                "units": API.units,
                ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
}
