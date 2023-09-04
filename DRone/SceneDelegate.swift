//
//  SceneDelegate.swift
//  DRone
//
//  Created by Mihai Ocnaru on 17.08.2023.
//

import UIKit
import SwiftUI


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static var mainNavigation: Navigation = Navigation()
    
    var window: UIWindow?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.mainNavigation.setRoot(
            LoginView()
                .preferredColorScheme(.dark)
                .asDestination(tag: "LoginView")
            , animated: true)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: RootView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}


