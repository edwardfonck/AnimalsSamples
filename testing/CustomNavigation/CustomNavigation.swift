//
//  CustomNavigation.swift
//  testing
//
//  Created by Eduardo Fonseca on 11/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

final class CustomNavigationController : UINavigationController {
    override func viewDidLoad() {
        // Find size for blur effect.
        let statusBar = self.view?.window?.windowScene?.statusBarManager
        let statusBarHeight = statusBar?.statusBarFrame.height ?? 0
        let bounds = UINavigationBar.appearance().bounds.insetBy(dx: 0, dy: -(statusBarHeight)).offsetBy(dx: 0, dy: -(statusBarHeight))
        // Create blur effect.
        let blur : UIView = UIView()
        blur.addBlur(style: .dark)
        blur.frame = bounds
        self.navigationBar.isTranslucent = true
        self.navigationItem.titleView?.tintColor = .white
        let navImg : UIImage? = UIImage(named: "navBarCustomBackground")
        self.navigationBar.setBackgroundImage(navImg?.withTintColor(.navColor), for: .default)

        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)]
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().insertSubview(blur, at: 0)
//        UINavigationBar.appearance().addSubview(blur)
    }
}
