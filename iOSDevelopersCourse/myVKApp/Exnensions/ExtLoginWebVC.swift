//
//  ExtLoginWebVC.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import WebKit


extension LoginWebVC: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let responseUrl = webView.request?.url, let _ = responseUrl.fragment else { return }
        AuthorizationRequest.setAuthorizationResult(url: responseUrl)
        
        if !(keyChain.string(forKey: "accessToken") == nil) {
            performSegue(withIdentifier: "showApp", sender: self)
        } else {
            performSegue(withIdentifier: "exit", sender: self)
        }
    }
}
