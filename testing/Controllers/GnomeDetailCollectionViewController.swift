//
//  GnomeDetailCollectionViewController.swift
//  testing
//
//  Created by Familia Fonseca López on 09/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

protocol GnomeDetailProtocol {
    func goToFriendDetail(selectedGnome:Gnome)
}

class GnomeDetailCollectionViewController: UICollectionViewController {
    var headerImageView : UIImageView? = nil
    var detailDelegate : GnomeDetailProtocol?
    
    static let gnomeDetailCellIdentifier = "commonCell"
    var gnomes : [Gnome] = []
    
    var gnomeDetail : Gnome? {
        didSet {
            guard let gnomeDetail = gnomeDetail else { return }
            self.gnomeDetailViewModel = GnomeDetailViewModel(selectedGnome: gnomeDetail, with: gnomes)
        }
    }
    
    var gnomeDetailViewModel : GnomeDetailViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: GnomesViewController.sectionHeaderElementKind,
            withReuseIdentifier: HeaderView.reuseIdentifier)
        self.collectionView.register(UINib.init(nibName: String(describing: CommonDetailCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: GnomeDetailCollectionViewController.gnomeDetailCellIdentifier)
        self.collectionView.register(UINib.init(nibName: String(describing: GnomesCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: GnomesViewController.gnomeCellIdentifier)
        setupCollectionParallax()
    }
    
    func setupCollectionParallax(){
        self.collectionView.backgroundColor = .navColor
        self.collectionView.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = generateLayout()
    }
    
    fileprivate func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            let sectionLayoutKind = DetailsSections.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .Summary: return   GnomeFeedCompositionalLayout().featuredGnomesCompositionalLayout(isWide: true)
            case .Friends: return GnomeFeedCompositionalLayout().searchCollectionLayout()
            case .Professions: return GnomeFeedCompositionalLayout().searchCollectionLayout()
            }
        }
        return layout
    }
    
}
extension GnomeDetailCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return SummaryImages.allCases.count
        case 1:
            return self.gnomeDetailViewModel?.numberOfFriends ?? 0
        case 2:
            return self.gnomeDetailViewModel?.numberOfProfessions ?? 0
        default:
            return 0
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DetailsSections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
        
        supplementaryView.label.text = DetailsSections.allCases[indexPath.section].rawValue
        return supplementaryView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch indexPath.section {
        case 1:
        guard let _ = self.gnomeDetailViewModel,let cell = collectionView.dequeueReusableCell(withReuseIdentifier:GnomesViewController.gnomeCellIdentifier, for: indexPath) as? GnomesCollectionViewCell else { return UICollectionViewCell() }
            self.gnomeDetailViewModel?.setupGnomeDetailCell(with: cell, indexPath: indexPath)
            return cell
        default:
            guard let _ = self.gnomeDetailViewModel, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commonCell", for: indexPath) as? CommonDetailCollectionViewCell  else { return UICollectionViewCell() }
            self.gnomeDetailViewModel?.setupGnomeDetailCell(with: cell, indexPath: indexPath)
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let friend = self.gnomeDetailViewModel?.getSelectedGnomeFromFriends(index: indexPath.item) else { return }
            self.detailDelegate?.goToFriendDetail(selectedGnome:friend)
        default:
            debugPrint("default")
        }
        
    }
}

extension GnomeDetailCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let statusBarheight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 60
        let y = -scrollView.contentOffset.y
        let maxY = max(y,(navigationBarHeight + statusBarheight))
        headerImageView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: maxY)
    }
}
