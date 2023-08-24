//
//  NotificationService.swift
//  DRone
//
//  Created by Mihai Ocnaru on 24.08.2023.
//

import SwiftUI
import NotificationCenter
import Combine

class NotificationService {
    static let shared = NotificationService()
    
    private init() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                print("User granted permission for notification")
            case .denied:
                print("User denied notification permission")
                DispatchQueue.main.async {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            case .notDetermined:
                print("Notification permission haven't been asked yet")
                DispatchQueue.main.async {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            case .provisional:
                // @available(iOS 12.0, *)
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                // @available(iOS 14.0, *)
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknow Status")
            }
        })
    }
    
    func postNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
