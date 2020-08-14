//
//  GnomeDetailViewModel.swift
//  testing
//
//  Created by Eduardo Fonseca on 12/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import Foundation
import UIKit

enum DetailsSections : String, CaseIterable {
    case Summary = "Summary"
    case Friends = "Friends"
    case Professions = "Professions"
}

enum SummaryImages : String , CaseIterable {
    case heightIconName = "arrow.up.and.down.square"
    case widthIconName = "arrow.left.and.right.square"
    case ageIconName = "app.gift"
    case hairColorIconName = "circle.fill"
    case friendsIconName = "person.3"
    case ProfessionsIconName = "briefcase"
}

struct GnomeDetailViewModel {
    private var selectedGnome : Gnome?
    private var allGnomes : [Gnome]? = []
    private var gnomeFriends : [Gnome]? = []
    
    init(selectedGnome:Gnome, with allGnomes:[Gnome]){
        self.selectedGnome = selectedGnome
        self.allGnomes = allGnomes
        fillFriends()
    }
    
    var numberOfFriends :Int? {
        self.selectedGnome?.friends.count
    }
    
    var numberOfProfessions :Int? {
        self.selectedGnome?.professions.count
    }
    
    fileprivate mutating func fillFriends(){
        guard let FriendsOfGnome = self.selectedGnome?.friends,FriendsOfGnome.count > 0,let allgnomes = self.allGnomes else { return }
        self.gnomeFriends?.removeAll()
//        for nameGnome : String in FriendsOfGnome {
//            let filteredArray = allgnomes.filter{$0.name == nameGnome}
//            for obj in filteredArray {
//                self.gnomeFriends?.append(obj)
//            }
//        }
        for nameGnome : String in FriendsOfGnome {
            guard let friend = allgnomes.first(where: {
                $0.name == nameGnome
            }) else { return }
            self.gnomeFriends?.append(friend)
        }
    }
    
    func getSelectedGnomeFromFriends(index:Int) -> Gnome? {
        return self.gnomeFriends?[index]
    }
}

extension GnomeDetailViewModel {
    
    func setupGnomeDetailCell<T:UICollectionViewCell>(with cell:T?, indexPath:IndexPath) {
        let blur : UIView = UIView().addBlur(style: .extraLight)
        switch indexPath.section {
        case 0:
            let cell = cell as? CommonDetailCollectionViewCell
            cell?.titleSection.isHidden = false
            cell?.conceptIcon.image = UIImage(systemName: SummaryImages.allCases[indexPath.item].rawValue, withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withTintColor(.white, renderingMode: .alwaysOriginal)
            cell?.conceptTitle.text = getCurrentConcept(at: indexPath.item).key
            cell?.conceptSubtitle.text = getCurrentConcept(at: indexPath.item).value
            cell?.backgroundView =  blur
            break
        case 1:
            let cell = cell as? GnomesCollectionViewCell
            cell?.nameTitle.text = self.selectedGnome?.friends[indexPath.item]
            cell?.gnomeThumbnail.asyncImage(from: self.gnomeFriends?.count ?? 0 > 0  ? self.gnomeFriends?[indexPath.item].thumbnail : self.selectedGnome?.thumbnail)
            break
        case 2:
            let cell = cell as? CommonDetailCollectionViewCell
            cell?.titleSection.isHidden = true
            cell?.conceptIcon.image = UIImage(systemName: SummaryImages.ProfessionsIconName.rawValue, withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withTintColor(.white, renderingMode: .alwaysOriginal)
            cell?.conceptSubtitle.text = self.selectedGnome?.professions[indexPath.item]
            cell?.backgroundView =  blur
            break
        default:
            debugPrint("default")
        }
    }
    
    fileprivate func getCurrentConcept(at index:Int) -> (key: String, value:String) {
        guard let selectedGnome = self.selectedGnome else { return ("","")}
        switch index {
        case 0:
            let raw = Double(selectedGnome.height)
            return ("Height",String(format: "%.2f", raw))
        case 1:
            let raw = Double(selectedGnome.weight)
            return ("Weight",String(format: "%.2f", raw))
        case 2:
            return ("Age","\(selectedGnome.age)")
        case 3:
            return ("Hair color","\(selectedGnome.hair_color)")
        case 4:
            return ("No. Friends","\(selectedGnome.friends.count)")
        case 5:
            return ("No. Professions","\(selectedGnome.professions.count)")
        default:
            debugPrint("default")
            return ("","")
        }
    }
}
