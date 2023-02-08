//
//  AppDelegate.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        FirebaseApp.configure()
        preloadData()
        return true
    }

    // MARK: - Предзагрузка данных для CoreData
    private func preloadData() {
        let defaults = UserDefaults.standard

        if defaults.bool(forKey: "preloadData") == false {
            PreloadData.shared.preloadData()
            defaults.set(true, forKey: "preloadData")
        }
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

}
