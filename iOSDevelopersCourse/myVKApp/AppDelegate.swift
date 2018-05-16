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

        checkRequests()
        
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
        
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = configuration
        
        print(configuration.fileURL!)
        
        FirebaseApp.configure()
        return true
    }
    
    private func checkRequests() {
        dispatchGroup.enter()
        FriendsRequests.getIncomingFriendsRequest() {
            self.dispatchGroup.leave()
        }
    }
}

