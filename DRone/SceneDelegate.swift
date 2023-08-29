//
//  SceneDelegate.swift
//  DRone
//
//  Created by Mihai Ocnaru on 17.08.2023.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static var navigation: Navigation = Navigation()
    var window: UIWindow?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            SceneDelegate.navigation = Navigation(root:
                LoginView(viewModel: LoginViewModel())
                .environmentObject(SceneDelegate.navigation)
                    .preferredColorScheme(.dark)
                    .asDestination()
            )
            window.rootViewController = UIHostingController(rootView: RootView(navigation: SceneDelegate.navigation))
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


