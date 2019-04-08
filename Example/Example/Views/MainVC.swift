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
            
            collectionView.register(UINib(nibName: SectionHeaderView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
            collectionView.register(UINib(nibName: SectionFooterView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterView.reuseIdentifier)
            collectionView.register(UINib(nibName: ItemCVCell.nibName, bundle: nil), forCellWithReuseIdentifier: ItemCVCell.reuseIdentifier)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var numberOfColumns = 2
    
    var sections = SectionDataProvider.shared.sections
    
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
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            view.setup(withSection: sections[indexPath.section])
            return view
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterView.reuseIdentifier, for: indexPath) as! SectionFooterView
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCVCell.reuseIdentifier, for: indexPath) as! ItemCVCell
        cell.setup(withItem: sections[indexPath.section].items[indexPath.item], preferredWidthForCell: collectionView.frame.width / CGFloat(numberOfColumns) - 10)
        
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
        return (section + 1) % numberOfColumns == 0 ? 0 : 10.0
    }

    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenRowsBelow section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, interitemSpacingInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10/2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForSupplementaryElementOfKind kind: String, section: Int) -> CGSize {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10/2, height: 100)
        case UICollectionView.elementKindSectionFooter:
            return CGSize(width: collectionView.frame.width / CGFloat(numberOfColumns) - 10/2, height: 100)
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
