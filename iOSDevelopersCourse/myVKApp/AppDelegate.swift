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
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var requestsCount = 0
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
        guard let userId = userId, let accessToken = accessToken else { return }
        print("Start Background loading")
        if lastUpadte != nil, abs(lastUpadte!.timeIntervalSinceNow) < 30 {
            print("Updating is not needed")
            completionHandler(.noData)
            return
        }
        
        requestsCount = 0

        dispatchGroup.enter()
        FriendsRequests.getIncomingFriendsRequest() { [weak self] requests in
            self?.requestsCount += requests
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = self?.requestsCount ?? 0
                self?.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        DialogsRequests.getUserDialogs(userId: userId, accessToken: accessToken) { [weak self] dialogs in
            let dialogCount = dialogs.filter( {$0.readState == 0 && $0.out == 0 } ).count
            
            self?.requestsCount += dialogCount
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = self?.requestsCount ?? 0
                self?.dispatchGroup.leave()
            }
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let path = url.absoluteString
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! UITabBarController
        
        if path == "myVKAppWidget://News" {
            initVC.selectedIndex = 0
            self.window?.rootViewController = initVC
        } else if path == "myVKAppWidget://Dialogs" {
            initVC.selectedIndex = 1
            self.window?.rootViewController = initVC
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    private func configureRealm() {
        let configuration = Realm.Configuration(
            fileURL: FileManager
                .default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.myVKApp")?.appendingPathComponent("default.realm"),
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [User.self, Friend.self, FriendRequest.self, Photos.self, Group.self, News.self, NewsAttachments.self, Dialog.self, Message.self, MessageAttachments.self])
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


