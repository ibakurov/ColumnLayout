//
//  ViewController.swift
//  Example
//
//  Created by Illya Bakurov on 4/2/19.
//  Copyright © 2019 Illya Bakurov. All rights reserved.
//

import UIKit
import MultiColumnLayout

class MainVC: UIViewController {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let multiColumnLayout = MultiColumnLayoutCollectionViewLayout()
            multiColumnLayout.dataSource = self
            collectionView.setCollectionViewLayout(multiColumnLayout, animated: false)
            
            collectionView.register(UINib(nibName: AccountInfoCVCell.nibName, bundle: nil), forCellWithReuseIdentifier: AccountInfoCVCell.reuseIdentifier)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var numberOfColumns = 2
    
    var accounts = AccountDataProvider.shared.accounts
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

//-----------------
// MARK: - UICollectionViewDataSource
//-----------------
extension MainVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountInfoCVCell.reuseIdentifier, for: indexPath) as! AccountInfoCVCell
        cell.setup(withAccount: accounts[indexPath.item])
        return cell
    }
}

//-----------------
// MARK: - MultiColumnLayoutCollectionViewLayoutDataSource
//-----------------
extension MainVC: MultiColumnLayoutCollectionViewLayoutDataSource {
    
    func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        return numberOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenColumnsAfter section: Int) -> CGFloat {
        return 10.0
    }
//
//    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenRowsBelow section: Int) -> CGFloat {
//        return 1.0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, interitemSpacingInSection section: Int) -> CGFloat {
//        return 2.0
//    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10, height: 100)
    }
    
//    func collectionView(_ collectionView: UICollectionView, sizeForHeaderOf section: Int) -> CGSize {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, sizeForFooterOf section: Int) -> CGSize {
//        <#code#>
//    }
}

//-----------------
// MARK: - UICollectionViewDelegate
//-----------------
extension MainVC: UICollectionViewDelegate {
    
    
}
