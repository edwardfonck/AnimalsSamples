//
//  Storyboarded.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
