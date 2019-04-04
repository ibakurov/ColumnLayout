//
//  InstitutionHeaderView.swift
//  Example
//
//  Created by Illya Bakurov on 4/3/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import UIKit

class InstitutionHeaderView: SelfSizingHeightReusableView, Reusable {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    @IBOutlet weak var institutionTitleLbl: UILabel!
    
    override func prepareForReuse() {
        institutionTitleLbl.text = nil
        
        super.prepareForReuse()
    }
}

//-----------------
// MARK: - Setup
//-----------------
extension InstitutionHeaderView {
    
    func setup(withInstitution institution: Institution) {
        institutionTitleLbl.text = institution.institutionTitle
    }
}
