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
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var requestsCount = 0
    let dispatchGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpadte: Date? {
        get { return UserDefaults.standard.object(forKey: "LastUpdate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "LastUpdate") }
    }
    var wsSession: WCSession?
    var newsArray: Results<News>!
    var newsFeed = [[String:String]]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureNotifications()
        RealmConfigurator.configureRealm()
        
        FirebaseApp.configure()
        configureWSSession()
        return true
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
    
    private func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: .badge) { _, error in
            if error != nil { print(error.debugDescription) }
        }
    }
    
    private func configureWSSession() {

        if WCSession.isSupported() {
            wsSession = WCSession.default
            wsSession?.delegate = self
            wsSession?.activate()
        }
    }
    
    private func fillNewsArray() {
        
        newsArray = RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
        newsFeed.removeAll()
        
        for new in newsArray {
            newsFeed.append(["author": new.author ?? "",
                             "date": Date(timeIntervalSince1970: new.date).formatted,
                             "text": new.text,
                             "url": new.attachments.first?.url ?? ""
                ])
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        fillNewsArray()
        
        if message["request"] as? String == "news" {
            replyHandler(["newsFeed": newsFeed])
            
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith: ", activationState.rawValue)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {


    }
}

