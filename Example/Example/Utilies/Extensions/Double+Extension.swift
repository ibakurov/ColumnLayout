//
//  Double+Extension.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import Foundation

public extension Double {
    
    func marketValue() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)
    }
}
