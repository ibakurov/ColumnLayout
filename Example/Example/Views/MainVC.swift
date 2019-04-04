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
            
            collectionView.register(UINib(nibName: InstitutionHeaderView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InstitutionHeaderView.reuseIdentifier)
            collectionView.register(UINib(nibName: DisclosureFooterView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DisclosureFooterView.reuseIdentifier)
            collectionView.register(UINib(nibName: AccountInfoCVCell.nibName, bundle: nil), forCellWithReuseIdentifier: AccountInfoCVCell.reuseIdentifier)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var numberOfColumns = 1
    
    var institutions = InstitutionDataProvider.shared.institutions
    
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
        return institutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return institutions[section].accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InstitutionHeaderView.reuseIdentifier, for: indexPath) as! InstitutionHeaderView
            view.setup(withInstitution: institutions[indexPath.section])
            return view
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DisclosureFooterView.reuseIdentifier, for: indexPath) as! DisclosureFooterView
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountInfoCVCell.reuseIdentifier, for: indexPath) as! AccountInfoCVCell
        cell.setup(withAccount: institutions[indexPath.section].accounts[indexPath.item])
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

    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenRowsBelow section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, interitemSpacingInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForSupplementaryElementOfKind kind: String, section: Int) -> CGSize {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10, height: 100)
        case UICollectionView.elementKindSectionFooter:
            return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10, height: 100)
        default:
            return .zero
        }
    }
}

//-----------------
// MARK: - UICollectionViewDelegate
//-----------------
extension MainVC: UICollectionViewDelegate {
    
    
}
