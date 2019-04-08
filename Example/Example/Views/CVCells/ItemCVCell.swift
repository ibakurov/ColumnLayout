//
//  ItemCVCell.swift
//  Example
//
//  Created by Illya Bakurov on 4/2/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import UIKit

class ItemCVCell: SelfSizingHeightCVCell, Reusable {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    @IBOutlet weak var itemTitleLbl: UILabel!
    private var preferredWidthForCell: CGFloat = 0
    
    //-----------------
    // MARK: - Prepare For Reuse
    //-----------------

//    override func layoutSubviews() {
//        itemTitleLbl.preferredMaxLayoutWidth = preferredWidthForCell
//        super.layoutSubviews()
//    }
    
    override func prepareForReuse() {
        itemTitleLbl.text = nil
        contentView.backgroundColor = .clear
        
        super.prepareForReuse()
    }
    
}

//-----------------
// MARK: - Setup
//-----------------
extension ItemCVCell {
    
    func setup(withItem item: Item, preferredWidthForCell width: CGFloat) {
        itemTitleLbl.text = item.itemTitle
        contentView.backgroundColor = item.itemColor
//        itemTitleLbl.preferredMaxLayoutWidth = width-30
//        preferredWidthForCell = width
    }
}
