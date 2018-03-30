//
//  LoginWebVC.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import WebKit
import SwiftKeychainWrapper

class LoginWebVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    let keyChain = KeychainWrapper.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthtirozationRequest()
    }
    
    func loadAuthtirozationRequest() {
        DispatchQueue.global(qos: .utility).async {
            let request = AuthorizationRequest.requestAuthorization()
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                s.webView.loadRequest(request)
            }
        }
    }
}
