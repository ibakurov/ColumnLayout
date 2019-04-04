//
//  AccountInfoCVCell.swift
//  Example
//
//  Created by Illya Bakurov on 4/2/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import UIKit

class AccountInfoCVCell: UICollectionViewCell, Reusable {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    @IBOutlet weak var accountTitleLbl: UILabel!
    @IBOutlet weak var marketValueLbl: UILabel!
    @IBOutlet weak var lastSynDateLbl: UILabel!
    @IBOutlet weak var lastSyncStatusView: UIView! {
        didSet {
            lastSyncStatusView.layer.cornerRadius = 5.0
        }
    }
    
    //-----------------
    // MARK: - Prepare For Reuse
    //-----------------

    override func prepareForReuse() {
        accountTitleLbl.text = nil
        marketValueLbl.text = nil
        lastSynDateLbl.text = nil
        lastSyncStatusView.backgroundColor = .clear
        
        super.prepareForReuse()
    }
    
}

//-----------------
// MARK: - Setup
//-----------------
extension AccountInfoCVCell {
    
    func setup(withAccount account: Account) {
        accountTitleLbl.text = account.accountTitle
        marketValueLbl.text = account.marketValue?.marketValue()
        lastSynDateLbl.text = account.lastSyncDate?.toString(withDateFormat: "MMMM dd, yyyy, hh:mm Z")
        if let lastSyncStatus = account.lastSyncStatus {
            lastSyncStatusView.backgroundColor = lastSyncStatus == .successful ? #colorLiteral(red: 0, green: 0.6867282391, blue: 0.4519346356, alpha: 1) : #colorLiteral(red: 0.9321255088, green: 0.1348294914, blue: 0.04655506462, alpha: 1)
        } else {
            lastSyncStatusView.backgroundColor = #colorLiteral(red: 0.9321255088, green: 0.1348294914, blue: 0.04655506462, alpha: 1)
        }
    }
}
