//
//  SectionHeaderView.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import UIKit

class SectionHeaderView: SelfSizingHeightReusableView, Reusable {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    @IBOutlet weak var sectionTitleLbl: UILabel!
    
    override func prepareForReuse() {
        sectionTitleLbl.text = nil
        
        super.prepareForReuse()
    }
}

//-----------------
// MARK: - Setup
//-----------------
extension SectionHeaderView {
    
    func setup(withSection section: Section) {
        sectionTitleLbl.text = section.sectionTitle
    }
}
