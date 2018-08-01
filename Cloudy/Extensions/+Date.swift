//
//  +Date.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

extension Date {
    func dateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func dayOfWeek(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self).capitalized
    }
}
