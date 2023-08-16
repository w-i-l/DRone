//
//  DRoneApp.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import netfox
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        NFX.sharedInstance().start()
        return true
    }
}

@main
struct DRoneApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RequestDetailsView(formModel: RequestFormModel(
                firstName: "Mihai",
                lastName: "Ocnaru",
                CNP: "5031008450036",
                birthday: Date(),
                currentLocation: CLLocationCoordinate2D(),
                serialNumber: "F7D2K01",
                droneType: .agrar,
                takeoffTime: Date(),
                landingTime: Date(),
                flightLocation: CLLocationCoordinate2D()
            ))
                .preferredColorScheme(.dark)
        }
    }
}
