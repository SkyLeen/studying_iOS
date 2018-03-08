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
    
    let authorizationRequest = AuthorizationRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthtirozationRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showApp" else { return }
        guard let destVC = segue.destination as? UITabBarController else { return }
        
        guard let navVC = destVC.viewControllers?.first as? UINavigationController else { return }
        guard let friendsVC = navVC.viewControllers.first as? MyFriendsTableVC else { return }
        friendsVC.accessToken = authorizationRequest.authorization.accessToken
        friendsVC.userId = authorizationRequest.authorization.userId
        
        guard let navGroupVC = destVC.viewControllers?[1] as? UINavigationController else { return }
        guard let groupsVC = navGroupVC.viewControllers.first as? MyGroupsTableVC else { return }
        groupsVC.accessToken = authorizationRequest.authorization.accessToken
        groupsVC.userId = authorizationRequest.authorization.userId
    }
    
    func loadAuthtirozationRequest() {
        let request = authorizationRequest.requestAuthorization()
        webView.loadRequest(request)
    }
}

extension LoginWebVC: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let responseUrl = webView.request?.url, let _ = responseUrl.fragment else { return }
        authorizationRequest.setAuthorizationResult(url: responseUrl)
        
        if !(authorizationRequest.authorization.accessToken == "") {
            performSegue(withIdentifier: "showApp", sender: self)
        } else {
            performSegue(withIdentifier: "exit", sender: self)
        }
    }
}
