//
//  Date+Extension.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import Foundation

public extension Date {
    
    func toString(withDateFormat dateFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
