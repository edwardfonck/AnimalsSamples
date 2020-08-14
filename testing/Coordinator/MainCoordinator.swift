//
//  MainCoordinator.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: CustomNavigationController

    init(navigationController: CustomNavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        let vc = GnomesViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func gnomeDetail(selectedGnome : Gnome, allGnomes:[Gnome]) {
        let child = GnomeDetailCoordinator(navigationController: navigationController, with: selectedGnome, allGnomes: allGnomes)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in
            childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at:index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool){
        guard let fromNavigationController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromNavigationController) {
            return
        }
        //Remove gnome Detail Coordonator from coordinator´s stack
        if let detailGnomeViewController = fromNavigationController as? GnomeDetailViewController {
            childDidFinish(detailGnomeViewController.detailcoordinator)
        }
    }
    
}
