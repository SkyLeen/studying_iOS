//
//  InterfaceController.swift
//  myVKAppWatch Extension
//
//  Created by Natalya on 01/06/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import WatchKit
import WatchConnectivity

struct NewsFeed {
    var author: String
    var date: String
    var text: String
    var url: String
    
    init(author: String, date: String, text: String, url: String) {
        self.author = author
        self.date = date
        self.text = text
        self.url = url
    }
}

class InterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    @IBOutlet var authorLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var textLabel: WKInterfaceLabel!
    @IBOutlet var newsImage: WKInterfaceImage!
    
    var wsSession: WCSession?
    
    var newsFeed = [NewsFeed]()
    
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
            configureTableView()
            sendRequest()
        } else {
            print("Smth goes wrong")
        }
    }
}

extension InterfaceController {
    
    private func sendRequest() {
        wsSession?.sendMessage(["request":"news"],
                               replyHandler: { (reply) in
                                guard let newsArray = reply["newsFeed"] as? [[String:String]] else { return }
                                for news in newsArray {
                                    if let author = news["author"],
                                        let date = news["date"],
                                        let text = news["text"],
                                        let url = news["url"] {
                                        self.newsFeed.append(NewsFeed(author: author, date: date, text: text, url: url))
                                    }
                                }
                                self.configureTableView()
        },
                               errorHandler: { (error) in
                                print(error.localizedDescription)
        })
    }
    
    private func configureTableView() {
        tableView.setNumberOfRows(newsFeed.count, withRowType: "TableCell")
        for (index, news) in newsFeed.enumerated() {
            let row = tableView.rowController(at: index) as? TableCell
            row?.newsImage.setImage(nil)
            row?.authorLabel.setText(news.author)
            row?.dateLabel.setText(news.date)
            row?.textLabel.setText(news.text)
            row?.newsImage.setHeight(33)
            row?.newsImage.setWidth(33)
            DispatchQueue.global(qos: .background).async {
            if let url = URL(string: news.url),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                    row?.newsImage.setImage(image)
                }
            }
        }
    }
    
    private func configureWSSession() {
        if WCSession.isSupported() {
            wsSession = WCSession.default
            wsSession?.delegate = self
            wsSession?.activate()
        }
    }
}
