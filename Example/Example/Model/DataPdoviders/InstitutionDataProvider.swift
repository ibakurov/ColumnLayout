//
//  InstitutionDataProvider.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import Foundation

public class InstitutionDataProvider {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    static let shared = InstitutionDataProvider()
    
    public var institutions: [Institution] = []
    private var institutionNames: [String] = ["Royal Bank of Canada", "TD Bank", "Bank of Montreal", "Scotiabank", "DUCA Bank", "Questrade", "Robinhood", "CIBC Bank"]
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    //This has been purposefully kept private to force usage of shared
    private init() {
        for _ in 0..<institutionNames.count {
            if let randomInstitutionTitle = institutionNames.randomElement() {
                institutions.append(Institution(institutionTitle: randomInstitutionTitle, accounts: AccountDataProvider.shared.accounts))
            }
        }
    }
    
    
}
