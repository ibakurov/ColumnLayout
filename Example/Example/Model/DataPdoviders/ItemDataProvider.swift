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
    let allColors: [UIColor] = [#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)]
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    //This has been purposefully kept private to force usage of shared
    init() {
        for i in 0..<Int.random(in: 1..<10) {
            if i == 2 {
                items.append(contentsOf: [
                    Item(itemTitle: "VERY LONG TEXT HERE AND IT SHOULD EXPAND THIS CELL", itemColor: allColors.randomElement()!)
                ])
            } else {
                items.append(contentsOf: [
                    Item(itemTitle: "\(i)", itemColor: allColors.randomElement()!)
                ])
            }
        }
    }
    
}
