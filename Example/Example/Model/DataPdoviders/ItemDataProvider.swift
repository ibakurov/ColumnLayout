//
//  ItemDataProvider.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import UIKit

public class ItemDataProvider {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    var items: [Item] = []
    let allColors: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    //This has been purposefully kept private to force usage of shared
    init() {
        for i in 0..<Int.random(in: 1..<10) {
            items.append(contentsOf: [
                Item(itemTitle: "\(i)", itemColor: allColors.randomElement()!)
            ])
        }
    }
    
}
