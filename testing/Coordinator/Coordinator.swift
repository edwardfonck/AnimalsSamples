//
//  Coordinator.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: CustomNavigationController { get set }

    func start()
}
