//
//  InterfaceController.swift
//  myVKAppWatch Extension
//
//  Created by Natalya on 01/06/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    var wsSession: WCSession?
    private var defaults = UserDefaults(suiteName: "group.myVKApp")
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    } ()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        
        configureWSSession()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            wsSession?.sendMessage(["request":"news"],
                                   replyHandler: { (reply) in
                                    print(reply["newsFeed"] ?? "no data")
            },
                                   errorHandler: { (error) in
                                    print(error.localizedDescription)
            })
        } else {
            print("Smth goes wrong")
        }
    }
}

extension InterfaceController {
    
    private func configureWSSession() {
        if WCSession.isSupported() {
            wsSession = WCSession.default
            wsSession?.delegate = self
            wsSession?.activate()
        }
    }
}
