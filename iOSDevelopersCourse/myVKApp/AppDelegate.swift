//
//  AppDelegate.swift
//  iOSDevelopersCourse
//
//  Created by Natalya on 17/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dispatchGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpadte: Date? {
        get {
            return UserDefaults.standard.object(forKey: "LastUpdate") as? Date
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "LastUpdate")
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Start Background loading")
        if lastUpadte != nil, abs(lastUpadte!.timeIntervalSinceNow) < 30 {
            print("Updating is not needed")
            completionHandler(.noData)
            return
        }

        dispatchGroup.enter()
        FriendsRequests.getIncomingFriendsRequest() { requests in
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = requests
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Data was loaded in the background")
            self.timer = nil
            self.lastUpadte = Date()
            completionHandler(.newData)
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now() + 29, leeway: .seconds(1))
        timer?.setEventHandler {
            print("Data was not loaded")
            self.dispatchGroup.suspend()
            completionHandler(.failed)
            return
        }
        timer?.resume()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureNotifications()
        configureRealm()
        FirebaseApp.configure()
        return true
    }
    
    private func configureRealm() {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = configuration
        
        print(configuration.fileURL!)
    }
    
    private func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: .badge) { _, error in
            if error != nil { print(error.debugDescription) }
        }
    }
}

