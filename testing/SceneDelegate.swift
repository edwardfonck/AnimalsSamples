//
//  SceneDelegate.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator : MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
//        let navController = UINavigationController()
//        navController.navigationBar.barTintColor = UIColor.navColor
//        navController.navigationItem.largeTitleDisplayMode = .always
//
//        coordinator = MainCoordinator(navigationController: navController)
//        coordinator?.start()
//
//        window?.rootViewController = navController
//        window?.makeKeyAndVisible()
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let navController = CustomNavigationController()
        setupNavBarExtras()
        navController.navigationItem.largeTitleDisplayMode = .automatic
//        navController.navigationItem.backBarButtonItem?.tintColor = .white
//        UILabel.appearance().tintColor = .white
//        navController.navigationBar.isTranslucent = true
//        navController.navigationBar.barTintColor = UIColor.navColor
        
//        navController.navigationBar.barTintColor = UIColor.navColor
        // Don't forget to add var coordinator: MainCoordinator? to the top of the class
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    fileprivate func setupNavBarExtras(){
        let newFont = UIFont(name: "Avenir Next", size: 18.0)!
        let color = UIColor.white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: newFont], for: .normal)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

