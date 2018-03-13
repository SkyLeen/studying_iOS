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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
    }
    
    @IBAction func logOut(segue: UIStoryboardSegue) {
        LogOutRequest().logOut()
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        logIn()
    }
    
    func logIn() {
        guard !userDefaults.bool(forKey: "isLogged") else {
            self.performSegue(withIdentifier: "goToApplication", sender: self)
            return
        }
        self.performSegue(withIdentifier: "showAuthorization", sender: self)
    }
}
