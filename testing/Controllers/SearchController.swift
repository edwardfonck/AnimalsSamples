//
//  SearchController.swift
//  testing
//
//  Created by Familia Fonseca López on 07/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SearchProtocol {
    @objc optional func searchActive()
    @objc optional func searchDidChange(searchText:String?)
    @objc optional func reloadDataBySelectedScope(scopeOption:Int)
    @objc optional func resetCollectionValues()
}

class SearchController : UISearchController {
    private let searchScopeOptions = ["All","No friends","No professions"]
    var gnomeSearchDelegate : SearchProtocol?
    
    lazy var searchC : UISearchController = {
        var sc = UISearchController(searchResultsController: nil)
        DispatchQueue.main.async {
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = true
        sc.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search & filter gnomes...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.80)])
        sc.searchBar.searchTextField.textColor = .white
        sc.searchBar.searchTextField.tintColor = .white
        sc.searchBar.sizeToFit()
        sc.searchBar.searchBarStyle = .prominent
        sc.searchBar.scopeButtonTitles = self.searchScopeOptions
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        }
        return sc
    }()
}

extension SearchController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchC.searchBar
        let scope = searchBar.selectedScopeButtonIndex
        self.gnomeSearchDelegate?.reloadDataBySelectedScope?(scopeOption: scope)
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         self.gnomeSearchDelegate?.searchActive?()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.gnomeSearchDelegate?.searchDidChange?(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchC.searchBar.text = ""
        self.searchC.searchBar.selectedScopeButtonIndex = 0
        self.gnomeSearchDelegate?.resetCollectionValues?()
    }
}
