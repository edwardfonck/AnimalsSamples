//
//  ViewController.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit
import Foundation
import Combine

enum Section: String, CaseIterable {
    case featuredGnomes = "Featured Gnomes"
    case allGnomes = "All Gnomes"
}

class GnomesViewController: UICollectionViewController, Storyboarded {
    //Constants
    let searchC = SearchController()
    //    private let gnomeCell : GnomesCollectionViewCell! = UIView.fromNib()
    static let gnomeCellIdentifier = "GnomeIdentifier"
    static let sectionHeaderElementKind = "section-header-element-kind"
    //Variables
    private let refreshControl = UIRefreshControl()
    var gnomesSuscriber : AnyCancellable? //combine var to fetch data from publisher
    weak var coordinator : MainCoordinator?
    
    var gnomesViewModel : GnomesFeedViewModel? {
        didSet {
            self.collectionView.reloadData()
            self.endRefresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchC.gnomeSearchDelegate = self
        self.navigationItem.searchController = searchC.searchC
        definesPresentationContext = true
        setupCollection()
        fetchBrastlewarkGnomes()
    }
    
    fileprivate func setupCollection(){
        self.collectionView.collectionViewLayout = generateLayout()
        self.collectionView.refreshControl = refreshControl
        self.collectionView.refreshControl?.addTarget(self, action: #selector(fetchBrastlewarkGnomes), for: .valueChanged)
        self.collectionView.register(UINib.init(nibName: String(describing: GnomesCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: GnomesViewController.gnomeCellIdentifier)
        self.collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: GnomesViewController.sectionHeaderElementKind,
            withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let isFilterActive : Bool = self.gnomesViewModel?.filterStatus == FilterStatus.Filter
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .featuredGnomes: return isFilterActive ? GnomeFeedCompositionalLayout().searchCollectionLayout() :GnomeFeedCompositionalLayout().featuredGnomesCompositionalLayout(isWide: isWideView)
            case .allGnomes: return GnomeFeedCompositionalLayout().feedGnomesCompositionalLayout()
            }
        }
        return layout
    }
    
    fileprivate func startRefresh() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
        }
    }
    
    fileprivate func endRefresh() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension GnomesViewController {//API and fetch data for present desire info
    @objc func fetchBrastlewarkGnomes() {
        self.startRefresh()
        self.gnomesSuscriber = GnomesService().gnomesPublishers.sink(receiveCompletion: { error in
            debugPrint("error fetch : \(error)")
            self.endRefresh()
        }, receiveValue: { (gnomes) in
            self.gnomesViewModel = GnomesFeedViewModel(with: gnomes.Brastlewark)
            debugPrint("gnomes recieved : \(gnomes.Brastlewark)")
        })
    }
}

extension GnomesViewController { // Collection data source and delegates
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
        supplementaryView.label.text = self.gnomesViewModel?.filterStatus == FilterStatus.Filter ? "Results: \(self.gnomesViewModel?.filteredGnomes?.count ?? 0) gnome matches" :Section.allCases[indexPath.section].rawValue
        return supplementaryView
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let _ = self.gnomesViewModel else { return 0 }
        return self.gnomesViewModel?.filterStatus == FilterStatus.Filter ? 1 : 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = self.gnomesViewModel else { return 0 }
        let isFilterActive : Bool = self.gnomesViewModel?.filterStatus == FilterStatus.Filter
        let maxItems =  isFilterActive ? 0 : self.gnomesViewModel?.getGnomesList()?.count ?? 0 >= 20 ? 20 : self.gnomesViewModel?.getGnomesList()?.count
        return isFilterActive ? self.gnomesViewModel?.filteredGnomes?.count ?? 0 : (section == 0 ? maxItems : self.gnomesViewModel?.getGnomesList()?.count ?? 0) ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:GnomesViewController.gnomeCellIdentifier, for: indexPath) as? GnomesCollectionViewCell else { return UICollectionViewCell() }
        self.gnomesViewModel?.setupGnomeCell(with: cell, AtIndex: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedGnome = self.gnomesViewModel?.getGnome(atIndex: indexPath.item) else {debugPrint("El gnome seleccionado es nulo"); return }
        searchC.searchC.searchBar.resignFirstResponder()
        coordinator?.gnomeDetail(selectedGnome: selectedGnome, allGnomes: self.gnomesViewModel?.getAllGnomes() ?? [])
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isFilterActive : Bool = self.gnomesViewModel?.filterStatus == FilterStatus.Filter
        if indexPath.section == 0 && !isFilterActive {
            cell.alpha = 0.2
            UIView.animate(withDuration: 0.75, animations: {
                cell.alpha = 1.0
            })
        }else {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity,0,100,0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.layer.removeAllAnimations()
    }
}

extension GnomesViewController : SearchProtocol {
    func searchActive(){
        if self.gnomesViewModel?.filterStatus == FilterStatus.NoFilter {
            self.gnomesViewModel?.filterStatus = FilterStatus.Filter
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout = self.generateLayout()
                
            }
        }
    }
    
    func searchDidChange(searchText: String?) {
        self.gnomesViewModel?.filterGnomes(with: searchText)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func reloadDataBySelectedScope(scopeOption: Int) {
        self.gnomesViewModel?.searchEscope = self.getSelectedScope(selectedScope: scopeOption)
        self.searchDidChange(searchText: searchC.searchC.searchBar.text ?? "")
        DispatchQueue.main.async {
            self.resetCollectionScroll() 
            self.collectionView.reloadData()
        }
    }
    
    func getSelectedScope(selectedScope:Int) -> SearchScopeOtions {
        switch selectedScope {
        case 1:
            return SearchScopeOtions.NoFriends
        case 2:
            return SearchScopeOtions.NoProfessions
        default:
            return SearchScopeOtions.All
        }
    }
    
    func resetCollectionValues(){
        self.gnomesViewModel?.filteredGnomes?.removeAll()
        self.gnomesViewModel?.filterStatus = FilterStatus.NoFilter
        self.gnomesViewModel?.searchEscope = SearchScopeOtions.All
        self.collectionView.collectionViewLayout = self.generateLayout()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.resetCollectionScroll()
        }
    }
    
    func resetCollectionScroll() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
        })
    }
}
