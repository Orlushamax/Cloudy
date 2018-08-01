//
//  +String.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

extension String {
    
    func stringToDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func uppercaseFirstCharacter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.uppercaseFirstCharacter()
    }
}
