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
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        FirebaseApp.configure()
        GMSServices.provideAPIKey(LocationAPI.GOOGLE_GEO_API_KEY)
        GMSPlacesClient.provideAPIKey(LocationAPI.GOOGLE_GEO_API_KEY)
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
    
        application.registerForRemoteNotifications()
    
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      print(userInfo)
//
//      completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the silent background notification here
        // This method will be called when your app receives a remote notification in the background

        // Extract any data you need from the userInfo dictionary
        if let customData = userInfo["customData"] as? String {
            // Process the custom data
            print("Received custom data: \(customData)")
            
            // Perform background tasks, update data, etc.
            
            // Call the completion handler when you're done processing
            completionHandler(.newData) // Indicate whether new data was fetched
        } else {
            // Call the completion handler even if there's no custom data to process
            completionHandler(.noData)
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

      SceneDelegate.navigation.popToRoot(animated: false)
      AppService.shared.selectedTab.value = .request
      SceneDelegate.navigation.push(
        RequestDetailsView(viewModel: RequestDetailsViewModel(formModel: FirebaseService.shared.allFlightsRequests.value[FirebaseService.shared.indexOfModifiedFlightRequest.value])).asDestination(),
        animated: false
      )
    print(userInfo)

    completionHandler()
  }
}
