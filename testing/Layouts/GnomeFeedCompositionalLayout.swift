//
//  GnomeFeedCompositionalLayout.swift
//  testing
//
//  Created by Familia Fonseca López on 06/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class GnomeFeedCompositionalLayout {

    func feedGnomesCompositionalLayout() -> NSCollectionLayoutSection {
      let inset: CGFloat = 3
//
//      // Large item on top
//      let topItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(9/16))
//      let topItem = NSCollectionLayoutItem(layoutSize: topItemSize)
//      topItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
//
//      // Bottom item
//      let bottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
//      let bottomItem = NSCollectionLayoutItem(layoutSize: bottomItemSize)
//      bottomItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
//
//      // Group for bottom item, it repeats the bottom item twice
//      let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
//
//        let bottomGroupSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.33))
//
//      let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize, subitem: bottomItem, count: 2)
//
//     let bottomGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize2, subitem: bottomItem, count: 3)
//
//      // Combine the top item and bottom group
//        let fullGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.402))
//
//      let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: fullGroupSize, subitems: [topItem, bottomGroup,bottomGroup2])
//
//      let section = NSCollectionLayoutSection(group: nestedGroup)
//
//      let layout = UICollectionViewCompositionalLayout(section: section)
//
//      return layout
        
        // We have three row styles
        // Style 1: 'Full'
        // A full width photo
        // Style 2: 'Main with pair'
        // A 2/3 width photo with two 1/3 width photos stacked vertically
        // Style 3: 'Triplet'
        // Three 1/3 width photos stacked horizontally

        // First type. Full
        let fullPhotoItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3)))

        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
          top: inset,
          leading: inset,
          bottom: inset,
          trailing: inset)

        // Second type: Main with pair
        // 3
        let mainItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1.0)))

        mainItem.contentInsets = NSDirectionalEdgeInsets(
          top: inset,
          leading: inset,
          bottom: inset,
          trailing: inset)

        // 2
        let pairItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)))

        pairItem.contentInsets = NSDirectionalEdgeInsets(
          top: inset,
          leading: inset,
          bottom: inset,
          trailing: inset)

        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)),
          subitem: pairItem,
          count: 2)

        // 1
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [mainItem, trailingGroup])

        // Third type. Triplet
        let tripletItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)))

        tripletItem.contentInsets = NSDirectionalEdgeInsets(
          top: inset,
          leading: inset,
          bottom: inset,
          trailing: inset)

        let tripletGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/9)),
          subitems: [tripletItem, tripletItem, tripletItem])

        // Fourth type. Reversed main with pair
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [trailingGroup, mainItem])

        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(16/9)),
          subitems: [
            fullPhotoItem,
            mainWithPairGroup,
            tripletGroup,
            mainWithPairReversedGroup
          ]
        )

//        let sectionN = NSCollectionLayoutSection(group: nestedGroup)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: GnomesViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .none
        
//        var isWide = false
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalWidth(2/3))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        // Show one item plus peek on narrow screens, two items plus peek on wider screens
//        let groupFractionalWidth = isWide ? 0.475 : 0.90
//        let groupFractionalHeight: Float = isWide ? 1/3 : 2/3
//        let groupSize = NSCollectionLayoutSize(
//          widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
//          heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                heightDimension: .estimated(80))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//          layoutSize: headerSize,
//          elementKind: GnomesViewController.sectionHeaderElementKind, alignment: .top)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [sectionHeader]
//        section.orthogonalScrollingBehavior = .groupPaging
        
//        let itemSize = NSCollectionLayoutSize(
//          widthDimension: .fractionalWidth(1.0),
//          heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
//        let groupSize = NSCollectionLayoutSize(
//          widthDimension: .fractionalWidth(1.0),
//          heightDimension: groupHeight)
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)
//
//        let headerSize = NSCollectionLayoutSize(
//          widthDimension: .fractionalWidth(1.0),
//          heightDimension: .estimated(44))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//          layoutSize: headerSize,
//          elementKind: GnomesViewController.sectionHeaderElementKind,
//          alignment: .top)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [sectionHeader]

        
//        let layout = UICollectionViewCompositionalLayout(section: section)
        return section
    }
    
    func featuredGnomesCompositionalLayout(isWide:Bool) ->
    
        NSCollectionLayoutSection {
            let inset : CGFloat = 5
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(2/3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
            // Show one item plus peek on narrow screens, two items plus peek on wider screens
            let groupFractionalWidth =  isWide ? 0.475 : 0.90
            let groupFractionalHeight: Float = isWide ? 1/3 : 2/3
            let groupSize = NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
              heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(80))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
              layoutSize: headerSize,
              elementKind: GnomesViewController.sectionHeaderElementKind, alignment: .top)
    
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .groupPaging
            
//            let layout = UICollectionViewCompositionalLayout(section: section)
            return section
        }
    
    func listCollectionLayout() -> UICollectionViewCompositionalLayout {
                let inset : CGFloat = 10
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(2/3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
                // Show one item plus peek on narrow screens, two items plus peek on wider screens
                let groupFractionalWidth =  0.98
                let groupFractionalHeight: Float = 2/3
                let groupSize = NSCollectionLayoutSize(
                  widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
                  heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                group.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
                let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func searchCollectionLayout() -> NSCollectionLayoutSection {
                let inset : CGFloat = 5
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(2/3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
                // Show one item plus peek on narrow screens, two items plus peek on wider screens
                let groupFractionalWidth =  1.0
                let groupFractionalHeight: Float = 2/8
                let groupSize = NSCollectionLayoutSize(
                  widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
                  heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                group.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: GnomesViewController.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
}
