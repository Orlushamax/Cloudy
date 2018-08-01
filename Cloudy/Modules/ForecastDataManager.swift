//
//  ForecastViewControllerDataManager.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import RealmSwift

protocol ForecastDataManagerType: class {
    func getWeeklyWeather(cityName: String)
    func getCityList()
    func saveCityToRealm(city: City)
}

class ForecastDataManager: ForecastDataManagerType {
    
    private let apiClient = API()
    weak var view: ForecastViewType!
    
    init(view: ForecastViewType) {
        self.view = view
    }
}

extension ForecastDataManager {
    
    func getCityList() {
        do {
            let cityList = try Realm().objects(City.self).toArray(ofType: City.self)
            self.view.showCityList(cityList: cityList)
        } catch {
            print(error)
        }
    }
    
    func getWeeklyWeather(cityName: String) {
        view.activityIndicatorStartAnimating()
        API.getForecastWeather(cityName: cityName, completion: { [weak self] cityForecast, error    in
            guard let weakSelf = self else { return }
            if let cityForecast = cityForecast {
                let groupedForecast = weakSelf.groupForecast(forecast: Array(cityForecast.list))
                weakSelf.view.showForecast(forecast: groupedForecast)
                weakSelf.view.activityIndicatorStopAnimating()
            } else if (error != nil) {
                do {
                    if let cityForecast = try Realm().object(ofType: ForecastList.self, forPrimaryKey: "\(cityName)") {
                        let groupedForecast = weakSelf.groupForecast(forecast: Array(cityForecast.list))
                        weakSelf.view.showForecast(forecast: groupedForecast)
                        weakSelf.view.activityIndicatorStopAnimating()
                    }
                } catch {
                    print(error)
                }
            } else {
                weakSelf.view.showNoDataAlert()
            }
        })
    }
    
    func saveCityToRealm(city: City) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(city, update: true)
        }
    }
}

extension ForecastDataManager {
    
    //MARK: Sort and group forecast by days
    private func groupForecast(forecast: [Forecast]) -> [[Forecast]] {
        
        if  forecast.count < 1 {
            return [[]]
        }
        
        var dict: [String:[Forecast]] = [:]
        
        for weather in forecast {
            guard let weatherKey = weather.date.stringToDate(format: "yyyy-MM-dd HH:mm:ss")?.dateString(format: "YYYYMMdd") else { return [[]]}
            if (dict[weatherKey] == nil || dict[weatherKey]!.count < 1) {
                dict[weatherKey] = []
            }
            dict[weatherKey]?.append(weather)
        }
        
        var result: [[Forecast]] = []
        
        let sortedKeys = Array(dict.keys).sorted()
        for key in sortedKeys {
            result.append(dict[key]!)
        }
        
        return result
    }
}
