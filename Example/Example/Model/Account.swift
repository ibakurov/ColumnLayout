//
//  Account.swift
//  Example
//
//  Created by Illya Bakurov on 4/2/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import Foundation

public struct Account {
    
    //-----------------
    // MARK: - Enums
    //-----------------
    
    enum SyncStatus: Int {
        case successful, unsuccessful
    }
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    var accountTitle: String?
    var marketValue: Double?
    var lastSyncDate: Date?
    var lastSyncStatus: SyncStatus?
    
}
