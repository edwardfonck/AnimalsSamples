//
//  GnomeDetailCoordinator.swift
//  testing
//
//  Created by Eduardo Fonseca on 10/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class GnomeDetailCoordinator: Coordinator {
    weak var parentCoordinator : MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: CustomNavigationController
    var gnome : Gnome
    var gnomes : [Gnome]
    
    init(navigationController: CustomNavigationController, with selectedGnome : Gnome, allGnomes:[Gnome])
    {
        self.navigationController = navigationController
        self.gnome = selectedGnome
        self.gnomes = allGnomes
    }
    
    func start() {
        let vc = GnomeDetailViewController.instantiate()
        vc.detailcoordinator = self
        vc.selectedGnome = self.gnome
        vc.allGnomes = self.gnomes
        navigationController.pushViewController(vc, animated: true)
    }
}
