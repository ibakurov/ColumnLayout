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
    var distanceBetweenColumns: CGFloat = 10
    var collapsed = false
    
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
    
    //-----------------
    // MARK: - Action
    //-----------------
    
    @IBAction func numberOfColumnsChanged(_ sender: UISegmentedControl) {
        numberOfColumns = sender.selectedSegmentIndex + 1
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
        if collapsed {
            return 0
        } else {
            return sections[section].items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            view.setup(withSection: sections[indexPath.section])
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collapse)))
            return view
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterView.reuseIdentifier, for: indexPath) as! SectionFooterView
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    @objc func collapse() {
        collapsed = !collapsed
        collectionView.reloadData()
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
        return (section + 1) % numberOfColumns == 0 ? 0 : distanceBetweenColumns
    }

    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenRowsBelow section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, interitemSpacingInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - distanceBetweenColumns * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns), height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, sizeForSupplementaryElementOfKind kind: String, section: Int) -> CGSize {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return CGSize(width: (collectionView.frame.width - distanceBetweenColumns * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns) - distanceBetweenColumns, height: 40)
        case UICollectionView.elementKindSectionFooter:
            return CGSize(width: (collectionView.frame.width - distanceBetweenColumns * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns) - distanceBetweenColumns, height: 40)
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
