//
//  BannerViewController.swift
//  myVKApp
//
//  Created by Natalya on 12/06/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import Firebase

class BannerViewController : UIViewController {
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self;
        bannerView.adUnitID = "ca-app-pub-3215412991703994/3282073039"
        
        view.addSubview(bannerView)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        
        print("load ads")
    }
}
