//
//  TodayViewController.swift
//  myVKAppWidget
//
//  Created by Natalya on 27/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var authorNews: UILabel!
    @IBOutlet weak var recNews: UILabel!
    
    @IBOutlet weak var textNews: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
