//
//  SCCollectionViewLeftAlignedLayout.swift
//  CollectionViewLayoutDemo
//
//  Created by SamChiang on 2020/8/13.
//  Copyright © 2020 SamChiang. All rights reserved.
//

import UIKit

class SCCollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
           let originAttributes = super.layoutAttributesForElements(in: rect)
           return originAttributes?.map({ (attributes) -> UICollectionViewLayoutAttributes in
               self.layoutAttributesForItem(at: attributes.indexPath)!
           })
       }

       override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
           /// 获取当前的布局
           let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)
           let sectionInset = evaluatedSectionInsetForItem(at: indexPath.section)
           let isFirstItemSection = indexPath.item == 0
           let layoutWidth = (collectionView?.frame.width ?? 0) - sectionInset.left - sectionInset.right
           
           if isFirstItemSection {
               currentItemAttributes?.leftAlignFrame(sectionInset: sectionInset)
               return currentItemAttributes
           }
           let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
           let previousFrame = self.layoutAttributesForItem(at: previousIndexPath)?.frame
           let previousFrameRightPoint = (previousFrame?.origin.x ?? 0) + (previousFrame?.size.width ?? 0)
           let currentFrame = currentItemAttributes?.frame
           let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame?.origin.y ?? 0, width: layoutWidth, height: currentFrame?.size.height ?? 0)
           let isFirstItemInRow = !(previousFrame ?? CGRect.zero).intersects(strecthedCurrentFrame)
           if isFirstItemInRow {
               currentItemAttributes?.leftAlignFrame(sectionInset: sectionInset)
               return currentItemAttributes
           }
           var frame = currentItemAttributes?.frame
           frame?.origin.x = previousFrameRightPoint + self.evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
           currentItemAttributes?.frame = frame ?? CGRect.zero
           return currentItemAttributes
       }
       
       /// 计算当前 `section` 每个 `item` 之间的间距
       /// - Parameter sectionIndex: `section`
       /// - Returns: `item` 之间的间距
       func evaluatedMinimumInteritemSpacingForSection(at sectionIndex: Int) -> CGFloat {
           if let delegate = collectionView?.delegate as?  SCCollectionViewDelegateLeftAlignedLayout, let collectionView = self.collectionView {
               return delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex) ?? minimumInteritemSpacing
           } else {
               return self.minimumInteritemSpacing
           }
       }
       
       /// 计算当前的SectionInset
       /// - Parameter index: 当前的Section
       /// - Returns: `Section` 的`sectionInset`
       func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
           if let delegate = collectionView?.delegate as? SCCollectionViewDelegateLeftAlignedLayout, let collectionView = self.collectionView {
               return delegate.collectionView?(collectionView, layout: self, insetForSectionAt: index) ?? sectionInset
           } else {
               return sectionInset
           }
       }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

protocol SCCollectionViewDelegateLeftAlignedLayout: UICollectionViewDelegateFlowLayout {}
