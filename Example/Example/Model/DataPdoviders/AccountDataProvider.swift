//
//  AccountDataProvider.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import Foundation

public class AccountDataProvider {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    static let shared = AccountDataProvider()
    
    var accounts: [Account] = [
        Account(accountTitle: "Chequing Account", marketValue: 234234.23, lastSyncDate: Date(), lastSyncStatus: .successful),
        Account(accountTitle: "Savings Account", marketValue: 12344.23, lastSyncDate: Date(), lastSyncStatus: .unsuccessful),
        Account(accountTitle: "TFSA Account", marketValue: 324.34, lastSyncDate: Date(), lastSyncStatus: .successful)
    ]
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    //This has been purposefully kept private to force usage of shared
    private init() {
        
    }
    
    
}
