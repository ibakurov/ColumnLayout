//
//  SectionDataProvider.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import Foundation

public class SectionDataProvider {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    static let shared = SectionDataProvider()
    
    public var sections: [Section] = []
    private var sectionTitles: [String] = ["First", "Second", "Third", "Fourth", "Fifth"]
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    //This has been purposefully kept private to force usage of shared
    private init() {
        for sectionTitle in sectionTitles {
            sections.append(Section(sectionTitle: sectionTitle, items: ItemDataProvider().items))
        }
    }
    
    
}
