//
//  LoginFromController.swift
//  iOSDevelopersCourse
//
//  Created by Natalya on 17/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard userDefaults.bool(forKey: "isLogged") else { return }
        self.performSegue(withIdentifier: "missAuthorization", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func logOut(segue: UIStoryboardSegue) {
        LogOutRequest.logOut()
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showAuthorization", sender: self)
    }
}
