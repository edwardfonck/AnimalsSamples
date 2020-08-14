//
//  GnomesFeedViewModel.swift
//  testing
//
//  Created by Familia Fonseca López on 06/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import Foundation
import UIKit

enum SearchScopeOtions {
    case All, NoFriends, NoProfessions
}

enum FilterStatus {
    case NoFilter, Filter
}


struct GnomesFeedViewModel {
    private var gnomes : [Gnome]?
    private var noProfesionGnomes : [Gnome]?
    private var noFriendGnomes : [Gnome]?
    var filteredGnomes : [Gnome]? = []
    var filterStatus = FilterStatus.NoFilter
    var searchEscope = SearchScopeOtions.All
    
    init(with gnomes : [Gnome]) {
        self.gnomes = gnomes
        self.setupNoFriendsFilter()
        self.setupNoProfessionsFilter()
    }
}

extension GnomesFeedViewModel {// setup filter data
    fileprivate mutating func setupNoFriendsFilter() {
        guard let allGnomes = self.gnomes else { return }
        let allNoFriends = allGnomes.filter{$0.friends.count==0}
        self.noFriendGnomes = allNoFriends
    }
    
    fileprivate mutating func setupNoProfessionsFilter() {
           guard let allGnomes = self.gnomes else { return }
            let allNoFriends = allGnomes.filter{$0.professions.count==0}
            self.noProfesionGnomes = allNoFriends
    }
}

extension GnomesFeedViewModel { //Data Provider
    
    func getGnomesList() -> [Gnome]? {
        switch  searchEscope {
        case .NoFriends:
            return self.noFriendGnomes
        case .NoProfessions:
            return self.noProfesionGnomes
        default:
            return getAllGnomes()
        }
    }
    
    func getAllGnomes() -> [Gnome]? {
        return self.gnomes
    }
    
    func getGnome(atIndex index : Int) -> Gnome? {
        switch filterStatus {
        case .Filter:
            return filteredGnomes?[index]
        default:
           return getGnomesList()?[index]
        }
    }
}

extension GnomesFeedViewModel { //gnome collection fill data
    func setupGnomeCell(with cell:GnomesCollectionViewCell,AtIndex index:IndexPath) {
        let currentIndex = index.item
        
        
//        if index.section == 0 && filterStatus == FilterStatus.NoFilter { // config and configure de data source for feautured Gnomes
//            let totalItems = self.getGnomesList()?.count ?? 0
//            let randomInt = Int.random(in: 0..<totalItems)
//            currentIndex = randomInt
//        }
        
        guard let gnomeName = getGnome(atIndex: currentIndex)?.name,let urlImage = getGnome(atIndex: currentIndex)?.thumbnail else { return }
        //        cell.gnomeThumbnail.getImage(from: urlImage)
        cell.nameTitle.text = gnomeName
        cell.gnomeThumbnail.asyncImage(from: urlImage)
    }
    
}

extension GnomesFeedViewModel { // Filter Gnomes
    
    mutating func filterGnomes(with searchCriteria: String?) {
        if searchCriteria?.isEmpty ?? true && searchCriteria ?? "" == "" {
            self.filteredGnomes = self.getGnomesList()
        }else
        {
        let results = self.getGnomesList()?.filter{$0.name.uppercased().contains(searchCriteria?.uppercased() ?? "")}
        self.filteredGnomes = results
        }
    }
    
    mutating func resetValues() {
        searchEscope = .All
        filterStatus = .NoFilter
        self.filteredGnomes?.removeAll()
    }
    
}
