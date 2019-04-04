//
//  MultiColumnLayoutCollectionViewLayout.swift
//  AVA
//
//  Created by Illya Bakurov on 2017-12-13.
//  Copyright © 2017 Royal Bank of Canada. All rights reserved.
//

import UIKit

public protocol MultiColumnLayoutCollectionViewLayoutDataSource: class {
    func numberOfColumns(_ collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, sizeForSupplementaryElementOfKind kind: String, section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenColumnsAfter section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenRowsBelow section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, interitemSpacingInSection section: Int) -> CGFloat
}

public extension MultiColumnLayoutCollectionViewLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize { return .zero }
    func collectionView(_ collectionView: UICollectionView, sizeForSupplementaryElementOfKind kind: String, section: Int) -> CGSize { return .zero }
    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenColumnsAfter section: Int) -> CGFloat { return 0.0 }
    func collectionView(_ collectionView: UICollectionView, lineSpacingBetweenRowsBelow section: Int) -> CGFloat { return 0.0 }
    func collectionView(_ collectionView: UICollectionView, interitemSpacingInSection section: Int) -> CGFloat { return 0.0 }
}

public class MultiColumnLayoutCollectionViewLayout: UICollectionViewLayout {
    
    //-----------------
    // MARK: - Structs
    //-----------------
    
    fileprivate class SectionCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
        
        //----------------
        // MARK: - Variables
        //-----------------
        
        var sectionHeight: CGFloat = 0
        var sectionWidth: CGFloat = 0
        var lineSpacingBetweenColumnsAfterThisSection: CGFloat = 0
        var lineSpacingBetweenRowsBelowThisSection: CGFloat = 0
        
    }
    
    //----------------
    // MARK: - Variables
    //-----------------
    
    public weak var dataSource: MultiColumnLayoutCollectionViewLayoutDataSource?
    
    fileprivate var layoutAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var layoutAttributesForSupplementaryView = [IndexPath: [String: UICollectionViewLayoutAttributes]]()
    fileprivate var collectionViewContentWidth: CGFloat = 0
    fileprivate var collectionViewContentHeight: CGFloat = 0
    
    //----------------
    // MARK: - Layout Setup
    //-----------------
    
    override public func prepare() {
        guard let collectionView = collectionView else {
            fatalError("CustomCollectionViewLayout was attempted to be used on collection view, but no collection view was assigned as an owner of this layout")
        }
        assert(dataSource != nil, "dataSource object in CustomCollectionViewLayout is nil, so collection view will not be able to setup layout properly")
        
        //Reset data
        layoutAttributes.removeAll()
        layoutAttributesForSupplementaryView.removeAll()
        collectionViewContentWidth = 0
        collectionViewContentHeight = 0
        
        //Calculate content size of collection view first
        let collectionViewContentSize = calculateContentSize(forCollectionView: collectionView)
        collectionViewContentWidth = collectionViewContentSize.width
        collectionViewContentHeight = collectionViewContentSize.height
        
        //Calculate layout attributes for each item in the collection view
        var sectionAttributes = [Int: SectionCollectionViewLayoutAttributes]()
        let numberOfSections = collectionView.numberOfSections
        let numberOfColumns  = dataSource?.numberOfColumns(collectionView) ?? 1
        for section in 0..<numberOfSections {
            var sectionWidth: CGFloat  = 0
            var sectionHeight: CGFloat = 0
            var sectionOrigin: CGPoint = .zero
            
            // -----------------
            
            //Calculate sectionOrigin
            if section < numberOfColumns {
                //Calculate offset of section from the leading of the collection view, based on all previous sections
                for sectionsOnTheLeft in 0..<section {
                    if let sectionAttribute = sectionAttributes[sectionsOnTheLeft] {
                        sectionOrigin.x += sectionAttribute.sectionWidth + sectionAttribute.lineSpacingBetweenColumnsAfterThisSection
                    }
                }
                //Notice, that we don't need to calculate any additional y offset for the section in the first row, because it is only topInset which offsets sections in the first row by y coordinate.
            } else {
                //Calculate offset of section from the leading of the collection view, based on all previous sections
                for sectionsOnTheLeft in (Int(section / numberOfColumns) * numberOfColumns)..<section {
                    if let sectionAttribute = sectionAttributes[sectionsOnTheLeft] {
                        sectionOrigin.x += sectionAttribute.sectionWidth + sectionAttribute.lineSpacingBetweenColumnsAfterThisSection
                    }
                }
                //Calculate offset of section from the top of the collection view, based on all above sections
                for sectionsAbove in stride(from: (section % numberOfColumns), to: section, by: numberOfColumns) {
                    if let sectionAttribute = sectionAttributes[sectionsAbove] {
                        sectionOrigin.y += sectionAttribute.sectionHeight + sectionAttribute.lineSpacingBetweenRowsBelowThisSection
                    }
                }
            }
            
            // -----------------
            
            //Get proper layout attributes for header
            let headerSize = sizeOfViewForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, inCollectionView: collectionView, forIndexPath: IndexPath(item: 0, section: section))
            if headerSize.height > 0.0 {
                let headerOrigin = CGPoint(x: sectionOrigin.x, y: sectionOrigin.y)
                let headerCenter = CGPoint(x: sectionOrigin.x + headerSize.width / 2, y: sectionOrigin.y + headerSize.height / 2)
                
                //Generate proper UICollectionViewLayoutAttributes and assign appropriate data to it
                let headerAttribute               = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttribute.frame             = CGRect(origin: headerOrigin, size: headerSize)
                headerAttribute.size              = headerSize
                headerAttribute.center            = headerCenter
                
                layoutAttributesForSupplementaryView[IndexPath(item: 0, section: section)] = [UICollectionView.elementKindSectionHeader: headerAttribute]
                
                if headerSize.width > sectionWidth {
                    sectionWidth = headerSize.width
                }
                sectionHeight += headerSize.height
            }
            
            // -----------------
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            let interitemSpacingInSection = dataSource?.collectionView(collectionView, interitemSpacingInSection: section) ?? 0.0
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                
                //Calculating the origin (x, y) point for the item.
                var originForItem: CGPoint = .zero
                originForItem.x = sectionOrigin.x
                originForItem.y += sectionOrigin.y + sectionHeight
                
                //Grab item data from data source about the size
                let sizeForItem = sizeOfCell(inCollectionView: collectionView, forIndexPath: indexPath)
                let centerForItem = CGPoint(x: sectionOrigin.x + sizeForItem.width / 2, y: originForItem.y + sizeForItem.height / 2)
                //Generate proper UICollectionViewLayoutAttributes and assign appropriate data to it
                let attribute               = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame             = CGRect(origin: originForItem, size: sizeForItem)
                attribute.size              = sizeForItem
                attribute.center            = centerForItem
                //Cache it for later use
                layoutAttributes[indexPath] = attribute
                
                //Add item size to section width and height
                if sizeForItem.width > sectionWidth {
                    sectionWidth = sizeForItem.width
                }
                sectionHeight += sizeForItem.height
                
                //If this is not the very last item, then add interitemSpacing to the section height
                if item < numberOfItems - 1 {
                    sectionHeight += interitemSpacingInSection
                }
            }
            
            // -----------------
            
            //Get proper layout attributes for footer
            let footerSize = sizeOfViewForSupplementaryElement(ofKind: UICollectionView.elementKindSectionFooter, inCollectionView: collectionView, forIndexPath: IndexPath(item: numberOfItems, section: section))
            if footerSize.height > 0.0 {
                let footerOrigin = CGPoint(x: sectionOrigin.x, y: sectionOrigin.y + sectionHeight)
                let footerCenter = CGPoint(x: footerOrigin.x + footerSize.width / 2, y: footerOrigin.y + footerSize.height / 2)
                
                //Generate proper UICollectionViewLayoutAttributes and assign appropriate data to it
                let footerAttribute               = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: numberOfItems, section: section))
                footerAttribute.frame             = CGRect(origin: footerOrigin, size: footerSize)
                footerAttribute.size              = footerSize
                footerAttribute.center            = footerCenter
                
                layoutAttributesForSupplementaryView[IndexPath(item: numberOfItems, section: section)] = [UICollectionView.elementKindSectionFooter: footerAttribute]
                
                if footerSize.width > sectionWidth {
                    sectionWidth = footerSize.width
                }
                sectionHeight += footerSize.height
            }
            
            // -----------------
            
            let sectionAttribute = SectionCollectionViewLayoutAttributes()
            sectionAttribute.sectionWidth = sectionWidth
            sectionAttribute.sectionHeight = sectionHeight
            sectionAttribute.lineSpacingBetweenColumnsAfterThisSection = dataSource?.collectionView(collectionView, lineSpacingBetweenColumnsAfter: section) ?? 0.0
            sectionAttribute.lineSpacingBetweenRowsBelowThisSection = dataSource?.collectionView(collectionView, lineSpacingBetweenRowsBelow: section) ?? 0.0
            sectionAttributes[section] = sectionAttribute
        }
        
    }
    
    /** Function calculates content size of collection view, based on contentInsets, numberOfColumns, numberOfSections, and lineSpacings between columns and rows. */
    fileprivate func calculateContentSize(forCollectionView collectionView: UICollectionView) -> CGSize {
        //We will be selecting the biggest values between those available. Imagine more than two columns collection view. It means, that the first row will have three sections, and it means that there will be two distances between sections 0 and 1, and sections 1 and 2. If there is more than one row, then distances between columns could be different in row 1 and row 2. We should find the maximum value among all rows for the line spacing between sections 0 and 1 or 3 and 4 or 6 and 7, etc.
        //The same logic goes for between rows distances
        var maxLineSpacingsBetweenColumns           = [CGFloat]()
        var maxLineSpacingsBetweenRows              = [CGFloat]()
        //Calculating maximum widths and height of sections for each column and row respectfully
        var maxWidthOfRows                          = [CGFloat]()
        var maxHeightOfColumns                      = [CGFloat]()
        var collectionViewContentWidth: CGFloat     = 0
        var collectionViewContentHeight: CGFloat    = 0
        
        collectionViewContentWidth  += collectionView.contentInset.left + collectionView.contentInset.right
        collectionViewContentHeight += collectionView.contentInset.top + collectionView.contentInset.bottom
        
        let numberOfSections = collectionView.numberOfSections
        let numberOfColumns  = dataSource?.numberOfColumns(collectionView) ?? 1
        let numberOfRows     = numberOfSections / numberOfColumns + (numberOfSections % numberOfColumns == 0 ? 0 : 1)
        for section in 0..<numberOfSections {
            var sectionWidth: CGFloat  = 0
            var sectionHeight: CGFloat = 0
            
            let lineSpacingBetweenColumns = dataSource?.collectionView(collectionView, lineSpacingBetweenColumnsAfter: section) ?? 0.0
            let lineSpacingBetweenRows    = dataSource?.collectionView(collectionView, lineSpacingBetweenRowsBelow: section) ?? 0.0
            
            let indexOfColumnBasedOnSection = section % numberOfColumns
            let indexOfRowBasedOnSection    = section / numberOfColumns
            
            let interitemSpacingInSection = dataSource?.collectionView(collectionView, interitemSpacingInSection: section) ?? 0.0
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                
                //Calculating lineSpacings
                //Check that this is not tha last column, because we do not want to add spacing between last column and an edge of the collection view
                if indexOfColumnBasedOnSection < numberOfColumns - 1 {
                    if maxLineSpacingsBetweenColumns.count > indexOfColumnBasedOnSection {
                        if lineSpacingBetweenColumns > maxLineSpacingsBetweenColumns[indexOfColumnBasedOnSection] {
                            maxLineSpacingsBetweenColumns[indexOfColumnBasedOnSection] = lineSpacingBetweenColumns
                        }
                    } else {
                        maxLineSpacingsBetweenColumns.append(lineSpacingBetweenColumns)
                    }
                }
                
                //Check that this is not tha last row, because we do not want to add spacing between last row and an edge of the collection view
                if indexOfRowBasedOnSection < numberOfRows {
                    if maxLineSpacingsBetweenRows.count > indexOfRowBasedOnSection {
                        if  lineSpacingBetweenRows > maxLineSpacingsBetweenRows[indexOfRowBasedOnSection] {
                            maxLineSpacingsBetweenRows[indexOfRowBasedOnSection] = lineSpacingBetweenRows
                        }
                    } else {
                        maxLineSpacingsBetweenRows.append(lineSpacingBetweenRows)
                    }
                }
                
                //Calcualting sizes
                let sizeForItem = sizeOfCell(inCollectionView: collectionView, forIndexPath: indexPath)
                if sizeForItem.width > sectionWidth {
                    sectionWidth = sizeForItem.width
                }
                sectionHeight += sizeForItem.height
                
                //If this is not the very last item, then add interitemSpacing to the section height
                if item < numberOfItems - 1 {
                    sectionHeight += interitemSpacingInSection
                }
            }
            
            let headerSize = sizeOfViewForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, inCollectionView: collectionView, forIndexPath: IndexPath(item: numberOfItems, section: section))
            let footerSize = sizeOfViewForSupplementaryElement(ofKind: UICollectionView.elementKindSectionFooter, inCollectionView: collectionView, forIndexPath: IndexPath(item: numberOfItems, section: section))
            
            if headerSize.width > sectionWidth {
                sectionWidth = headerSize.width
            }
            if footerSize.width > sectionWidth {
                sectionWidth = footerSize.width
            }
            sectionHeight += headerSize.height + footerSize.height
            
            if maxWidthOfRows.count > indexOfRowBasedOnSection {
                maxWidthOfRows[indexOfRowBasedOnSection] += sectionWidth
            } else {
                maxWidthOfRows.append(sectionWidth)
            }
            
            if maxHeightOfColumns.count > indexOfColumnBasedOnSection {
                maxHeightOfColumns[indexOfColumnBasedOnSection] += sectionHeight
            } else {
                maxHeightOfColumns.append(sectionHeight)
            }
        }
        
        for lineSpacingsBetweenColumns in maxLineSpacingsBetweenColumns {
            collectionViewContentWidth += lineSpacingsBetweenColumns
        }
        for lineSpacingsBetweenRows in maxLineSpacingsBetweenRows {
            collectionViewContentHeight += lineSpacingsBetweenRows
        }
        
        var maxWidthOfRow: CGFloat  = 0.0
        var maxHeightOfColumn: CGFloat = 0.0
        for width in maxWidthOfRows {
            if width > maxWidthOfRow {
                maxWidthOfRow = width
            }
        }
        for height in maxHeightOfColumns {
            if height > maxHeightOfColumn {
                maxHeightOfColumn = height
            }
        }
        collectionViewContentWidth  += maxWidthOfRow
        collectionViewContentHeight += maxHeightOfColumn
        
        return CGSize(width: collectionViewContentWidth, height: collectionViewContentHeight)
    }
    
    public override var collectionViewContentSize: CGSize {
        let sideInsets: CGFloat      = (collectionView?.contentInset.left ?? 0) + (collectionView?.contentInset.right ?? 0)
        let topBottomInsets: CGFloat = (collectionView?.contentInset.top ?? 0) + (collectionView?.contentInset.bottom ?? 0)
        return CGSize(width: collectionViewContentWidth - sideInsets, height: collectionViewContentHeight - topBottomInsets)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for (_, attribute) in layoutAttributes {
            if rect.intersects(attribute.frame) && attribute.frame.size != .zero {
                attributes.append(attribute)
            }
        }
        for (_, supplementaryAttributes) in layoutAttributesForSupplementaryView {
            for (_, attribute) in supplementaryAttributes {
                if rect.intersects(attribute.frame) && attribute.frame.size != .zero {
                    attributes.append(attribute)
                }
            }
        }
        return attributes
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForSupplementaryView[indexPath]?[elementKind]
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
}

extension MultiColumnLayoutCollectionViewLayout {
    
    func sizeOfCell(inCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> CGSize {
        let sizeForItem = dataSource?.collectionView(collectionView, sizeForItemAt: indexPath) ?? .zero
        var estimatedSizeForItem = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath).preferredLayoutAttributesFitting(UICollectionViewLayoutAttributes(forCellWith: indexPath)).size ?? sizeForItem
        if estimatedSizeForItem.width == 0 {
            estimatedSizeForItem.width = sizeForItem.width
        }
        if estimatedSizeForItem.height == 0 {
            estimatedSizeForItem.height = sizeForItem.height
        }
        return estimatedSizeForItem
    }
    
    func sizeOfViewForSupplementaryElement(ofKind kind: String, inCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> CGSize {
        var viewSize: CGSize = dataSource?.collectionView(collectionView, sizeForSupplementaryElementOfKind: kind, section: indexPath.section) ?? .zero
        var estimatedSizeForView = collectionView.dataSource?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath).preferredLayoutAttributesFitting(UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)).size ?? viewSize
        if estimatedSizeForView.width == 0 {
            estimatedSizeForView.width = viewSize.width
        }
        if estimatedSizeForView.height == 0 {
            estimatedSizeForView.height = viewSize.height
        }
        return estimatedSizeForView
    }
}
