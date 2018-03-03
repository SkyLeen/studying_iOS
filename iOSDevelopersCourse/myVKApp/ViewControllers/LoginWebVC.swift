//
//  LoginWebVC.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import WebKit

class LoginWebVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    let authorizationRequest = NetworkRequest()
    var authorizationResult = (type: AuthorizationResult.defaultResult, text: "Default")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        tryAuthorize()
    }
    
    func tryAuthorize() {
        let request = authorizationRequest.requestAuthorization()
        webView.loadRequest(request)
    }
}

extension LoginWebVC: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
         logIn()
    }
    
    func logIn() {
        guard let responseUrl = webView.request?.url else { return }
        authorizationResult = authorizationRequest.getAuthorizationResult(url: responseUrl)
        switch authorizationResult.type {
        case .accessToken:
            performSegue(withIdentifier: "showApp", sender: nil)
        case .error:
            performSegue(withIdentifier: "logOut", sender: self)
        case .defaultResult:
            print("Waiting for getting response")
        }
    }
    
    

}
