//
//  Appdelegate.swift
//  DRone
//
//  Created by Mihai Ocnaru on 17.08.2023.
//

import Foundation
import UIKit
import netfox
import FirebaseCore
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        FirebaseApp.configure()
        GMSServices.provideAPIKey(LocationAPI.GOOGLE_GEO_API_KEY)
        GMSPlacesClient.provideAPIKey(LocationAPI.GOOGLE_GEO_API_KEY)
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
