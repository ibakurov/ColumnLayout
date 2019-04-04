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
    
    var accounts: [Account] {
        return getRandomAccounts(fromSet: Set(allAccounts), count: Int.random(in: 3..<allAccounts.count))
    }
    private let accountTitles: [String] = ["Chequing Account", "Savings Account", "TFSA Account", "IRS Account", "RRSP Account", "401k Account", "Commodities", "Gold", "GICs", "CDs"]
    private var allAccounts: [Account] = []
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    //This has been purposefully kept private to force usage of shared
    private init() {
        for _ in 0..<accountTitles.count {
            if let randomAccountTitle = accountTitles.randomElement() {
                allAccounts.append(Account(accountTitle: randomAccountTitle, marketValue: Double.random(in: 0...1000000), lastSyncDate: Date(), lastSyncStatus: Account.SyncStatus(rawValue: Int.random(in: 0...1))))
            }
        }
    }
    
    private func getRandomAccounts(fromSet setWithAccounts: Set<Account>, count: Int) -> [Account] {
        var newArrayWithRandomElements: [Account] = []

        for _ in 0..<count {
            if let account = setWithAccounts.randomElement() {
                newArrayWithRandomElements.append(account)
            }
        }
        
        return newArrayWithRandomElements
    }
    
}
